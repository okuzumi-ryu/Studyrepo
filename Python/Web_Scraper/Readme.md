# Hinata Blog Scraper (Docker版)

Hinata坂46の公式ブログから指定メンバーの画像を取得するスクレイパーです。  
Dockerを使って簡単に環境構築・実行できます。

---

## 実行手順

1. **リポジトリをクローン / 作業ディレクトリに移動**

```bash
git clone <リポジトリURL>
cd hinata_scraper

2. **ファイル修正**
Hinata_Scraper.pyの以下変数をそれぞれ修正する。
TARGET_MEMBER_KEYはHinata_Member_vars.pyから好みのメンバー名を記載する。
SAVE_ROOTはローカル上で保存したいパスを記載する。
---
TARGET_MEMBER_KEY = "MATSUO_SAKURA"
SAVE_ROOT = "./hinata_blog"
---

3．Dockerイメージビルド
docker build -t hinata-scraper .

4．スクレイピング実行
docker run --rm -v $(pwd)/hinata_blog:/app/hinata_blog hinata-scraper
※Dockerコンテナは処理完了後に自動削除
