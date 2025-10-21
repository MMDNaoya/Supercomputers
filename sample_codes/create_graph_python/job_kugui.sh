#!/bin/bash
#PBS -q F1cpu
#PBS -l select=1
#PBS -N create_graph
#PBS -o job_create_graph.out
#PBS -e job_create_graph.err

pip install --user matplotlib
TMPDIR=="/work/${USER:0:5}/${USER}"
echo "=== Job started at $(date) ==="
time srun python create_graph_python.py
echo "=== Job finished at $(date) ==="