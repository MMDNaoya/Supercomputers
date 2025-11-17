現在利用可能なスーパーコンピュータとその利用法について説明する．

# 利用可能ノード一覧

<table>
  <thead>
    <tr>
      <th>所属/施設</th>
      <th>システム名 + ノード種別</th>
      <th>CPU</th>
      <th>メモリ</th>
      <th>GPU</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td rowspan="2"><a href="https://mdcl.issp.u-tokyo.ac.jp/scc/system/systembinfo">物性研 SYSTEM B otaka</a></td>
      <td>CPUノード</td>
      <td>AMD EPYC 7702（64コア×2）</td>
      <td>256 GB</td>
      <td>なし</td>
    </tr>
    <tr>
      <td>Fatノード</td>
      <td>Intel Xeon Platinum 8280（28コア×4）</td>
      <td>3 TB</td>
      <td>なし</td>
    </tr>
    <tr>
      <td rowspan="2"><a href="https://mdcl.issp.u-tokyo.ac.jp/scc/system/newsystemc">物性研 SYSTEM C kugui</a></td>
      <td>CPUノード</td>
      <td>AMD EPYC 7763（64コア×2）</td>
      <td>256 GB</td>
      <td>なし</td>
    </tr>
    <tr>
      <td>ACCノード</td>
      <td>AMD EPYC 7763（64コア）</td>
      <td>256 GB</td>
      <td>NVIDIA A100 GPU（40 GB×4）</td>
    </tr>
    <tr>
      <td rowspan="2"><a href="https://www.cc.u-tokyo.ac.jp/supercomputer/miyabi/service/">情報基盤センター MIYABI(準備中)</a></td>
      <td>Miyabi-C ノード</td>
      <td>Intel Xeon Max 9480（56コア×2）</td>
      <td>128 GiB</td>
      <td>なし</td>
    </tr>
    <tr>
      <td>Miyabi-G ノード</td>
      <td>NVIDIA Grace CPU（72コア）</td>
      <td>120 GB</td>
      <td>NVIDIA Hopper H100 GPU（96 GB）(<a href="miyabi_gpu.md">使い方</a>)</td>
    </tr>
  </tbody>
</table>

# スーパーコンピュータの使い方概説
## 公式文書
[物性研スパコン講習会 スパコンの使い方と諸注意 2018](https://mdcl.issp.u-tokyo.ac.jp/scc/wp/wp-content/uploads/2021/07/180424_orientation.pdf)
## スーパーコンピュータのノードの種類

スーパーコンピュータは多数の計算ノード（Compute Node）で構成され，ログインノード（Login Node）と実行ノード（Compute Node） の2種類がある．
ログインノードからジョブスケジューラにバッチを投入し，ジョブスケジューラが計算を実行ノードに割り当てる．

### ログインノード
- シェル操作，スクリプト作成，ジョブ送信（ジョブスケジューラ操作），データ送受信などを行う
- 多くの利用者が同時に利用するので，CPUやメモリを独占するような計算は行わない---当局から**厳しい指導**が入る可能性

### 実行ノード (計算ノード)
- ジョブスケジューラ（例：Slurm）を通して実際の計算を行う
- 計算時間や使用ノード数はジョブスケジューラで制御される
- 基本的にユーザがsshログインなどすることはない

## ジョブについて
スーパーコンピュータでいうジョブとは，ユーザーが実行したい計算処理やシミュレーションを，ジョブスケジューラに投入する単位である．  
ジョブは，計算機上で直接実行するのではなく，ジョブスケジューラを介して実行ノードに割り当てられる．これにより，多数の利用者が同時にシステムを利用しても，資源の競合を避けて効率的に計算を行うことができる．
ジョブスケジューラはジョブの指定に応じて複数のノードを並列動作させるなども行う．例えばMiyabi-Gは96GBメモリのGPU1枚しか持たないので，よりGPUメモリを必要とする計算をする際はその分のノードを並列して計算する．
ジョブの情報はジョブスクリプトというファイルに書き，それをジョブ投入コマンドでジョブスケジューラに投入する．
ジョブ投入コマンドはシステムによって異なるので，各システムのマニュアルを参照すること．


### ジョブに書くべき内容
- **実行するプログラムやスクリプトのパス**  
  - どの計算プログラムを実行するかを指定する．  
  - 例：`./my_simulation.x input.dat`  
- **入力ファイルやデータのパス**  
  - 計算に必要なデータや設定ファイルの場所を指定する．  
- **出力ファイルの保存先**  
  - 計算結果やログをどこに書き出すかを指定する．  
- **計算前の環境設定**  
  - モジュールのロードや環境変数の設定など．  
  - 例：`module load gcc/12.2.0`  
- **必要に応じた前処理や後処理**  
  - データの整形や計算後の整理などもジョブスクリプトに含められる．

### ジョブを投入する際に考慮すべきこと
- **計算規模の見積もり**  
  - 使用するノード数、CPUコア数、メモリ量、GPUの有無、計算時間などを適切に見積もる必要がある．  
  - 見積もりが不正確だと，ジョブが長時間待たされたり，途中で強制終了されることがある．
  - ジョブ実行ではノード種別・ノード数・稼働時間に応じてポイントを消費する．ポイントを使い切ると研究室全体でスパコンを使えなくなるため，必要最小限の構成でジョブを実行すること．
- **並列計算の管理**  
  - MPIやOpenMPなどの並列化方式に応じて，プロセス数やスレッド数を設定する必要がある．
- **ログ管理**  
  - 標準出力や標準エラー出力のファイル名を設定し，計算結果やエラー内容を追跡できるようにする．
  - インタラクティブノードを使うと，計算ノードと同じ環境で対話的にデバッグできる


# アカウント作成
## 鍵登録
それぞれのシステムの手順を参照すること
- [物性研](https://scm-web.issp.u-tokyo.ac.jp/scm/UserSupport/ssh-pubkey-regist-flow.html)
- [情報基盤センター]

※```ssh-keygen```は既存の鍵(githubとか研究室サーバとか)を上書きする場合があるので，```.ssh/id_rsa_ohtaka```のようにログイン先ごとに別の鍵を作成すること．


## ssh接続
```ssh アカウント名@ohtaka.issp.u-tokyo.ac.jp -i ~/.ssh/authorized_keys```
で接続できるのだが，
```ssh ohtaka```のようにして，いちいちユーザ名や接続先ipアドレスを打たなくてもssh接続できるようにする方法を説明する．



### 🐧 Linuxの場合
1. **ssh-agentを起動**
   ```bash
   eval "$(ssh-agent -s)"
   ```

2. **秘密鍵をエージェントに登録（パスフレーズを一度だけ入力）**
   ```bash
   ssh-add ~/.ssh/id_rsa_otaka
   ```

3. **`~/.ssh/config` を設定**
   ```bash
   Host ohtaka
       HostName ohtaka.issp.u-tokyo.ac.jp
       User username
       IdentityFile ~/.ssh/id_rsa_ohtaka
       AddKeysToAgent yes
   ```

4. **永続化する場合（ログイン時に自動で有効に）**
   `~/.bashrc` に以下を追記：
   ```bash
   eval "$(ssh-agent -s)" > /dev/null
   ssh-add ~/.ssh/id_rsa < /dev/null
   ```

---

### 🍎 macOSの場合

1. **鍵をキーチェーンに登録**
   ```bash
   ssh-add --apple-use-keychain ~/.ssh/id_rsa_ohtaka
   ```

2. **`~/.ssh/config` に設定**
linuxの場合と同じ

3. **結果**
   一度パスフレーズを入力すれば、次回以降はmacOSキーチェーンが自動で認証。


### 🪟 Windowsの場合（Windows 10以降）

#### 🔹 方法1：PowerShell + OpenSSH

1. **ssh-agentサービスを自動起動**
   ```powershell
   Set-Service ssh-agent -StartupType Automatic
   Start-Service ssh-agent
   ```

2. **鍵を登録**
   ```powershell
   ssh-add $env:USERPROFILE\.ssh\id_rsa
   ```

3. **`~/.ssh/config` に設定**
linuxの場合と同じ

→ 一度登録すれば、以後はパスフレーズ不要。

---

#### 🔹 方法2：PuTTY + Pageantを使う場合

1. Pageantを起動  
2. 秘密鍵（`.ppk`形式）を追加してパスフレーズを入力  
3. 常駐中は自動的に認証される  
