miyabi-gでGPUを使う方法

# CUDAプログラムの開発・実行方法

miyabi-gのログインノードにはGPUが無いらしいので，GPUを使うプログラムの動作確認やデバッグをログインノードでは行えないが，コンパイル自体は適したコンパイラの環境のモジュールをロードすれば可能だ．  
例えば執筆時点では```module avail```コマンドによって
```
----- /work/opt/local/modules/modulefiles/LNG/mpi/nvidia/24.9/nv-hpcx/24.9 -----
frontflow_blue/8.1             parmetis/4.0.3    revocap_coupler/2.1  
frontistr/5.6                  petsc-gpu/3.22.2  superlu_dist/9.0.0   
modylas/1.0.4                  phase/2024.01     trilinos/13.4.1      
mpi-fftw/3.3.10                phdf5/1.14.5      vfd-gds/1.0.2        
netcdf-fortran-parallel/4.6.1  pnetcdf/1.14.0    waitio/1.0           
netcdf-parallel/4.9.2          pt-scotch/7.0.5   
openfoam-gpu/v2412             qe/7.3.1          

--------- /work/opt/local/modules/modulefiles/LNG/compiler/nvidia/24.9 ---------
fftw/3.3.10      mt-metis/0.7.2        povray/3.7.0.10         
gsl/2.8          netcdf-cxx/4.3.1      revocap_refiner/1.1.01  
hdf5/1.14.5      netcdf-fortran/4.6.1  scotch/7.0.5            
magma-gpu/2.7.2  netcdf/4.9.2          superlu/7.0.0           
metis/4.0.3      nv-hpcx/24.9          superlu_mt/4.0.0        
metis/5.1.0      ompi-cuda/4.1.6-12.6  xabclib/1.03            

----------------- /work/opt/local/modules/modulefiles/LNG/util -----------------
apptainer/1.3.5  enroot/3.5.0          paraview/5.13.1  singularity/4.2.1  
bioperl/1.7.8    gatk/4.3.0.0          python/3.10.16   squashfuse/0.5.2   
bioruby/2.0.5    gocryptfs/2.4.0       qt/5.15.16       xcrypt/cecb323     
cmake/3.31.1     miniforge3/24.11.0-0  R/4.4.2          

----------------- /work/opt/local/modules/modulefiles/LNG/core -----------------
clang-grace/19.24.10  cuda/12.9       gcc/12.4.0    nvidia/25.1  
cuda/11.8             gcc-toolset/12  gcc/15.2.0    nvidia/25.3  
cuda/12.4             gcc-toolset/13  nvidia/24.5   nvidia/25.5  
cuda/12.6             gcc-toolset/14  nvidia/24.9   nvidia/25.9  
cuda/12.8             gcc/11.4.1      nvidia/24.11  

```
が得られる．最新のNVIDIA HPC SDK 25.9をロードして，実際にcudaプログラムをコンパイルしてみよう．

(TODO: 実際のCUDAプログラムの例と実行例を追加)


# torchのようなGPUを使うpythonライブラリを使う方法

## ログインノードでの環境構築
python仮想環境モジュールであるminiforgeがあるので，それをロードして好みのライブラリをインストールする．    
著者の好みにより，miniforgeの上からuvをインストールしてそのuvを使ってライブラリをインストールしていく．  
ログインノードにはGPUが無いので，**torchの自動インストールに頼るとGPUなしバージョンがインストールされる．**  
**必ず適したcudaバージョン用のパッケージを選択する**

```
# miniforge環境ロード
module load miniforge3/24.11.0-0

# condaによる環境作成
conda create -n myenv python=3.11
conda activate myenv

pip install uv
uv pip install torch torchvision --extra-index-url https://download.pytorch.org/whl/cu128
uv pip install huggingface albumentations # お好みのパッケージをインストールできる．

# 例えば~/my_packageに自作あるいはcloneしてきたpythonライブラリがあってそれをインストールするなら
uv pip install -e my_package
```

## 計算ノードでの実行
計算ノードでは例えば
```module load cuda/12.8 miniforge3/24.11.0-0 cudnn/9.10.1.4  nccl/2.26.2```  
によってcudaドライバなどの環境をロードする．cudaのバージョンはtorchインストール時と計算ノードでロードする時で同じにすることを推奨する．cudnnやncclも必要なら入れる．(多分いらない)

ログインノードで構築したpython環境をロードするため，
```
eval "$(conda shell.bash hook)"
conda activate myenv
```
を発行する．完全なジョブファイルは以下のようになる．

```
#!/bin/bash
#PBS -q debug-g
#PBS -l select=1
#PBS -N cellpose
#PBS -o job_cellpose.out
#PBS -e job_cellpose.err
#PBS -W group_list=gq32

## TMPDIR=="/work/${USER:0:5}/${USER}" miyabiではTMPDIRはノード内のSSDのパスを指す環境
cd ~/cellpose
module purge 
module load cuda/12.8 miniforge3/24.11.0-0 cudnn/9.10.1.4  nccl/2.26.2
eval "$(conda shell.bash hook)"
conda activate cellpose
nvidia-smi
echo "=== Job started at $(date) ==="
python -m my_package --hoge huga --foo bar
echo "=== Job finished at $(date) ==="

```

