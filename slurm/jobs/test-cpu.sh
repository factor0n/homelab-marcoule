#!/bin/bash
#SBATCH --job-name=test-cpu
#SBATCH --partition=batch
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH --mem=512M
#SBATCH --time=00:05:00
#SBATCH --output=/tmp/slurm-cpu-%j.out

echo "=== Job CPU stress test ==="
echo "Job ID: $SLURM_JOB_ID"
echo "Noeud: $SLURM_NODELIST"
echo "CPUs alloués: $SLURM_CPUS_PER_TASK"
echo "Début: $(date)"

stress-ng --cpu $SLURM_CPUS_PER_TASK --timeout 120s --metrics-brief

echo "Fin: $(date)"
echo "=== Terminé ==="
