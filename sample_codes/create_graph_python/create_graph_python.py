import os
import shutil
from pathlib import Path

import numpy as np
import matplotlib.pyplot as plt

def main(temp_dir):
    # temp_dir(高速ディスクのパス)にデータを一時保存し，後でホームディレクトリに送る
    
    # パラメータ設定
    m = 1.0       # 質量 [kg]
    k = 4.0       # バネ定数 [N/m]
    c = 0.4       # 減衰係数 [N·s/m]

    # 初期条件
    x0 = 1.0      # 初期変位 [m]
    v0 = 0.0      # 初期速度 [m/s]

    # 時間設定
    t_max = 20.0
    dt = 0.01
    t = np.arange(0, t_max, dt)

    # 配列の初期化
    x = np.zeros_like(t)
    v = np.zeros_like(t)

    # 初期条件代入
    x[0] = x0
    v[0] = v0

    # 時間積分 (オイラー法)
    for i in range(1, len(t)):
        a = (-c * v[i-1] - k * x[i-1]) / m  # 加速度
        v[i] = v[i-1] + a * dt
        x[i] = x[i-1] + v[i] * dt

    # 可視化
    plt.figure(figsize=(10, 6))
    plt.plot(t, x, label='Displacement (x)', color='royalblue', linewidth=2)
    plt.plot(t, v, label='Velocity (v)', color='orange', linewidth=1.5, linestyle='--')
    plt.title("Damped Harmonic Oscillator", fontsize=16)
    plt.xlabel("Time [s]")
    plt.ylabel("Value")
    plt.grid(True, alpha=0.3)
    plt.legend()
    plt.tight_layout()
    plt.savefig(Path(temp_dir) / "fig.png")
    shutil.copy(Path(temp_dir) / "fig.png", ".")

temp_dir = os.environ.get("TMPDIR") 
main(temp_dir)