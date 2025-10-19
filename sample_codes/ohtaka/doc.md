ohtakaに実際にジョブを投入する．

[@daikumatan(長尾 太介 (Daisuke Nagao))の資料](https://qiita.com/daikumatan/items/fa6e2069adf828b3428c)がわかりやすい．
実際に```sbatch job_failure.sh```と```sbatch job_sucsess.sh```を実行し，結果を確認せよ．

ohtaka環境特有の情報は以下
1. partition  
[公式ドキュメント](https://mdcl.issp.u-tokyo.ac.jp/scc/manual-B/SystemB_User%27s_Guide_Rev2.7_JP.pdf)(ユーザ名はアカウント名，パスワードは大学メールアドレスの@より前まで) p.37参照
2. 高速ディスク  
ログインノードから見えるホームディレクトリ```/home/グループ名/アカウント名```は低速なので，読み書きが計算のボトルネックになる可能性がある．  
```/work/グループ名/アカウント名```は定期的に空にされるが大容量(6TB)かつ高速アクセスが可能な領域であるので，プログラムの読み書きはそこで行い，計算終了後に```/home/グループ名/アカウント名```に計算結果ファイルを移動してくるのが良い．python風に書くと以下のような感じ．

```

result = process(element)
pickle.dump(result, "/work/group_name/account_name/result.dump")
try:
    shutil.copyfile("/work/group_name/account_name/result.dump", "/home/group_name/account_name/result.dump")
except:
    print("something happened copying result file to home.")
```
