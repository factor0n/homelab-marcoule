#!/bin/bash
#SBATCH --job-name=test-mem
#SBATCH --partition=batch
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=2G
#SBATCH --time=00:05:00
#SBATCH --output=/tmp/slurm-mem-%j.out

echo "=== Job Memory stress test ==="
echo "Job ID: $SLURM_JOB_ID"
echo "Mémoire demandée: 2 Go"
echo "Début: $(date)"

stress-ng --vm 1 --vm-bytes 1536M --timeout 120s --metrics-brief

echo "Fin: $(date)"
echo "=== Terminé ==="
