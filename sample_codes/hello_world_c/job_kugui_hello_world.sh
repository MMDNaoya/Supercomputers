#!/bin/bash
#PBS -q debug-c
#PBS -l select=1
#PBS -N hello_world_success
#PBS -o job_success.out
#PBS -e job_success.err
gcc hello_world_success.c -o executable
echo "=== Job started at $(date) ==="
time srun ./executable ##プログラム実行にはsrunコマンドを使用
echo "=== Job finished at $(date) ==="