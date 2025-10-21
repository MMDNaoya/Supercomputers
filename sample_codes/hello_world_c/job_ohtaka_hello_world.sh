#!/bin/bash
#SBATCH --partition=F1cpu
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --job-name=hello_world_success
#SBATCH --output=job_success.out
#SBATCH --error=job_success.err
gcc hello_world_success.c -o executable
echo "=== Job started at $(date) ==="
time srun ./executable ##プログラム実行にはsrunコマンドを使用
echo "=== Job finished at $(date) ==="