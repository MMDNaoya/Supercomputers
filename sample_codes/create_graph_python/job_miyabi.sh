#!/bin/bash
#PBS -q debug-c
#PBS -l select=1
#PBS -N create_graph
#PBS -o job_create_graph.out
#PBS -e job_create_graph.err
#PBS -W group_list=gq32

## TMPDIR=="/work/${USER:0:5}/${USER}" miyabiではTMPDIRはノード内のSSDのパスを指す環境変数

pip install --user matplotlib ## 計算ノードにプリインストールされていないパッケージはpipでインストール
echo "=== Job started at $(date) ==="
time python create_graph_python.py
echo "=== Job finished at $(date) ==="