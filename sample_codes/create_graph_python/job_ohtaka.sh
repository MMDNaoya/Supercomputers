#!/bin/bash
#SBATCH --partition=F1cpu
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --job-name=create_graph
#SBATCH --output=job_create_graph.out
#SBATCH --error=job_create_graph.err
## TMPDIR=="/work/${USER:0:5}/${USER}" miyabiではTMPDIRはノード内のSSDのパスを指す環境変数

pip install --user matplotlib
TMPDIR=="/work/${USER:0:5}/${USER}"
echo "=== Job started at $(date) ==="
time srun python create_graph_python.py
echo "=== Job finished at $(date) ==="