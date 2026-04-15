# Homelab HPC — Monitoring & Generative AI Platform

A full-stack HPC monitoring and generative AI inference infrastructure deployed on a Kubernetes (k3s) cluster, built on a single physical machine virtualized through Proxmox VE.

## Architecture

```
Proxmox VE 8.4 (HP Pavilion 15-n205sk, i5-4200U, 16 GB RAM)
└── VM Ubuntu Server 24.04 (10 GB RAM, 3 vCPU, 80 GB)
    └── k3s (Kubernetes single-node)
        ├── Namespace: monitoring
        │   ├── Prometheus (metrics collection)
        │   ├── Grafana (dashboards & visualization)
        │   ├── Node Exporter (system metrics)
        │   ├── Kube State Metrics (K8s metrics)
        │   └── Alertmanager (HPC alerts)
        ├── Namespace: ia
        │   ├── Ollama (LLM inference server)
        │   └── Open WebUI (ChatGPT-like web interface)
        └── SLURM (HPC job scheduler)
            ├── slurmctld (controller)
            └── slurmd (daemon)
```

## Tech Stack

| Component | Technology | Role |
|-----------|-----------|------|
| Hypervisor | Proxmox VE 8.4 | Virtualization |
| OS | Ubuntu Server 24.04 | Operating system |
| Orchestrator | k3s v1.34.6 | Container orchestration |
| Monitoring | Prometheus + Grafana | Metrics collection & visualization |
| HPC Scheduler | SLURM | Job scheduling & resource management |
| LLM Inference | Ollama | AI model serving |
| AI Interface | Open WebUI | ChatGPT-like web UI |

## Grafana Dashboards

### HPC Cluster Overview
- Real-time gauges: CPU, RAM, Disk usage
- Time series: CPU by mode (user/system/iowait), memory breakdown
- Network I/O and Disk I/O
- Kubernetes pod status, restart counter, active alerts
- Load average (1m / 5m / 15m)

### Generative AI Platform
- Ollama & Open WebUI status indicators
- Per-container CPU and RAM usage (Ollama vs WebUI)
- Network traffic for the IA namespace
- Container uptime and restart counters

## HPC Alerts

| Alert | Condition | Severity |
|-------|-----------|----------|
| HighCpuUsage | CPU > 90% for 5 min | Warning |
| HighMemoryUsage | RAM > 85% for 5 min | Warning |
| PodCrashLooping | Restart loop (15 min) | Critical |

## Project Structure

```
homelab-hpc/
├── README.md
├── monitoring/
│   └── values-monitoring.yaml      # Helm config for Prometheus + Grafana
├── slurm/
│   ├── slurm.conf                  # SLURM configuration
│   ├── cgroup.conf                 # Cgroups configuration
│   └── jobs/
│       ├── test-cpu.sh             # CPU stress test job
│       └── test-memory.sh          # Memory stress test job
├── ia/
│   ├── ollama-deployment.yaml      # Ollama K8s deployment
│   └── open-webui-deployment.yaml  # Open WebUI K8s deployment
└── dashboards/
    ├── hpc-cluster.json            # Grafana HPC dashboard
    └── ia-platform.json            # Grafana AI dashboard
```

## Quick Start

### Prerequisites
- Proxmox VE with an Ubuntu Server 24.04 VM
- Internet access (direct or shared via NAT)

### Installation
```bash
# 1. Install k3s
curl -sfL https://get.k3s.io | sh -

# 2. Configure kubectl
mkdir -p ~/.kube
sudo cp /etc/rancher/k3s/k3s.yaml ~/.kube/config
sudo chown $(id -u):$(id -g) ~/.kube/config

# 3. Install Helm
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# 4. Deploy monitoring stack
kubectl create namespace monitoring
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm install monitoring prometheus-community/kube-prometheus-stack \
  --namespace monitoring \
  --values monitoring/values-monitoring.yaml

# 5. Install SLURM
sudo apt install -y slurm-wlm slurm-client munge
sudo cp slurm/slurm.conf /etc/slurm/slurm.conf
sudo cp slurm/cgroup.conf /etc/slurm/cgroup.conf
sudo systemctl enable --now munge slurmctld slurmd

# 6. Deploy AI platform
kubectl create namespace ia
kubectl apply -f ia/ollama-deployment.yaml
kubectl apply -f ia/open-webui-deployment.yaml
kubectl exec -it deployment/ollama -n ia -- ollama pull tinyllama
```

### Service Access
| Service | URL |
|---------|-----|
| Grafana | http://<VM_IP>:30300 |
| Open WebUI | http://<VM_IP>:<NodePort> |
| SLURM | `sinfo`, `squeue`, `sbatch` |

## Skills Demonstrated

- **Containerization & Orchestration**: Docker, Kubernetes (k3s), Helm
- **Monitoring**: Prometheus, Grafana, Alertmanager, Node Exporter
- **HPC**: SLURM, job scheduling, resource allocation, cgroups
- **AI/ML Ops**: LLM deployment (Ollama), web interface (Open WebUI)
- **Systems**: Linux, Proxmox, Netplan, iptables, NAT
- **Infrastructure as Code**: YAML manifests, Helm values, Bash scripts, Git
