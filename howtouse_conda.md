# Miyabi環境におけるConda（Miniforge）利用ガイド

## TL;DR
- **問題:** GPUノード（x86_64）とCPUノード（aarch64）でアーキテクチャが異なるため、通常の `conda init` は不整合を起こす．
- **解決策:** `.bashrc` にアーキテクチャ自動判別コードを記述し、`conda.sh` を直接ロードする．
- **メリット:** `module load` 不要．ログインするだけで全ノードで `conda activate` が使用可能となる．
- **注意:** 仮想環境（env）自体に互換性はないため、x86用とARM用で環境を分ける必要がある．

---

## 1. 背景：Miyabiの構成と課題
Miyabiは、計算資源によってCPUアーキテクチャが異なるヘテロジニアス構成を採用している．

| ノードタイプ | アーキテクチャ | 実行バイナリ形式 | 主な用途 |
| :--- | :--- | :--- | :--- |
| **GPUノード** | `x86_64` | Intel/AMD系 | GPU計算，AI学習 |
| **CPUノード** | `aarch64` | ARM系 | CPU並列計算 |

ホームディレクトリは全ノードで共有されているため、一方のノードで `conda init` を行うと、もう一方のノードにログインした際、不適切なパスが読み込まれる．その結果、`syntax error` や `unable to open X server` 等のエラーが発生する課題がある．

## 2. 推奨される `.bashrc` の設定
既存の `PATH` 設定を維持したまま、ノードのCPUに合わせて適切なConda環境をロードする．
**注意:** 以前 `conda init` によって自動挿入された `# >>> conda initialize >>>` ブロックはすべて削除してから追記すること．

```bash
# =================================================================
# 1. ユーザー固有のパス設定（既存の設定を維持）
# =================================================================
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]
then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# =================================================================
# 2. アーキテクチャ判別とCondaの自動ロード
# =================================================================
# ログインしたノードのCPUに合わせて参照パスを動的に切り替える [^1]
case "$(uname -m)" in
    x86_64)
        _CONDA_ROOT="/work/opt/local/x86_64/cores/miniforge3/24.11.0-0"
        ;;
    aarch64)
        _CONDA_ROOT="/work/opt/local/aarch63/cores/miniforge3/24.11.0-0"
        ;;
esac

# conda.shをsourceすることで、'conda'コマンドをシェル関数として定義する
# これにより、'module load'を実行しなくても直接 'conda activate' が可能となる [^2]
if [ -f "${_CONDA_ROOT}/etc/profile.d/conda.sh" ]; then
    . "${_CONDA_ROOT}/etc/profile.d/conda.sh"
fi

unset _CONDA_ROOT


Gemini の回答

承知いたしました。マニュアルの全容を、語尾は「だ・である」、句読点は「，」「．」で統一し、GitHubにそのまま貼り付けられるRaw Markdown（ソースコード形式）で提示する。
Markdown

# Miyabi環境におけるConda（Miniforge）利用ガイド

## TL;DR
- **問題:** GPUノード（x86_64）とCPUノード（aarch64）でアーキテクチャが異なるため、通常の `conda init` は不整合を起こす．
- **解決策:** `.bashrc` にアーキテクチャ自動判別コードを記述し、`conda.sh` を直接ロードする．
- **メリット:** `module load` 不要．ログインするだけで全ノードで `conda activate` が使用可能となる．
- **注意:** 仮想環境（env）自体に互換性はないため、x86用とARM用で環境を分ける必要がある．

---

## 1. 背景：Miyabiの構成と課題
Miyabiは、計算資源によってCPUアーキテクチャが異なるヘテロジニアス構成を採用している．

| ノードタイプ | アーキテクチャ | 実行バイナリ形式 | 主な用途 |
| :--- | :--- | :--- | :--- |
| **GPUノード** | `x86_64` | Intel/AMD系 | GPU計算，AI学習 |
| **CPUノード** | `aarch64` | ARM系 | CPU並列計算 |

ホームディレクトリは全ノードで共有されているため、一方のノードで `conda init` を行うと、もう一方のノードにログインした際、不適切なパスが読み込まれる．その結果、`syntax error` や `unable to open X server` 等のエラーが発生する課題がある．

## 2. 推奨される `.bashrc` の設定
既存の `PATH` 設定を維持したまま、ノードのCPUに合わせて適切なConda環境をロードする．
**注意:** 以前 `conda init` によって自動挿入された `# >>> conda initialize >>>` ブロックはすべて削除してから追記すること．

```bash
# =================================================================
# 1. ユーザー固有のパス設定（既存の設定を維持）
# =================================================================
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]
then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# =================================================================
# 2. アーキテクチャ判別とCondaの自動ロード
# =================================================================
# ログインしたノードのCPUに合わせて参照パスを動的に切り替える [^1]
case "$(uname -m)" in
    x86_64)
        _CONDA_ROOT="/work/opt/local/x86_64/cores/miniforge3/24.11.0-0"
        ;;
    aarch64)
        _CONDA_ROOT="/work/opt/local/aarch64/cores/miniforge3/24.11.0-0"
        ;;
esac

# conda.shをsourceすることで、'conda'コマンドをシェル関数として定義する
# これにより、'module load'を実行しなくても直接 'conda activate' が可能となる [^2]
if [ -f "${_CONDA_ROOT}/etc/profile.d/conda.sh" ]; then
    . "${_CONDA_ROOT}/etc/profile.d/conda.sh"
fi

unset _CONDA_ROOT
```
3. ジョブスクリプトでの利用例
計算ノードでジョブを実行する際は，環境の不整合を防ぐため，スクリプト内で明示的に conda.sh をロードすることを推奨する．
GPUノードで実行する場合の例
```
#!/bin/bash
#PBS -q debug-g
#PBS -l select=1
#PBS -N cellpose
#PBS -o job_cellpose.out
#PBS -e job_cellpose.err
#PBS -W group_list=gq32

## MiyabiではTMPDIRはノード内のSSDのパスを指す環境
cd ~/cellpose

# 既存のモジュールをリセットし，必要なライブラリをロード
module purge 
module load cuda/12.8 cudnn/9.10.1.4 nccl/2.26.2

# アーキテクチャに合わせたCondaの初期化（module load miniforge3の代わり）
# ノードがx86_64であることを前提としたパス指定
source /work/opt/local/x86_64/cores/miniforge3/24.11.0-0/etc/profile.d/conda.sh

# 環境の有効化と実行
conda activate cellpose_gpu
nvidia-smi
echo "=== Job started at $(date) ==="
python -m my_package --hoge huga --foo bar
echo "=== Job finished at $(date) ==="
```
 
5. 運用上の重要な注意点
① 仮想環境の「アーキテクチャ互換性」

Conda で作成した仮想環境（env）自体には互換性がない．

    x86_64 ノードで作成した環境は、aarch64 ノードでは動作しない．

    解決策: 環境名にアーキテクチャを明記して管理することを推奨する．

        例: myenv_x86 (GPUノード用)，myenv_arm (CPUノード用)

② module load との使い分け

本設定を行えば、module load miniforge3/... を実行する必要はない． module load は内部的に PATH を書き換えるだけの場合があり、本設定（シェル関数の直接定義）の方が conda activate 時の挙動が安定する．
③ 正しく設定されたかの確認

ログイン後、以下のコマンドを実行する．
```type conda```
結果が ```conda is a function```と表示されれば成功である．

③ conda module versionの陳腐化
現在のconda moduleのバージョン```24.11.0-0```がいつまで使えるかはわからない．エラーが出たらチェックすること．
