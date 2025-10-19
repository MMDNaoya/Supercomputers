#!/bin/bash
#SBATCH -p F1cpu
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -c 1
#SBATCH -J hello_world_success
#SBATCH -o job_success.out
#SBATCH -e job_success.err
gcc hello_world_success.c -o executable
echo "=== Job started at $(date) ==="
time srun ./executable ##プログラム実行にはsrunコマンドを使用
echo "=== Job finished at $(date) ==="