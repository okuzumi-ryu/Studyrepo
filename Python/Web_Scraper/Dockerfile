# ベースイメージ
FROM python:3.12-slim

# 作業ディレクトリ
WORKDIR /app

# 依存関係をコピーしてインストール
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# ソースコードをコピー
COPY Hinata_Scraper.py .
COPY Hinata_Member_vars.py .

# スクリプト実行
CMD ["python", "Hinata_Scraper.py"]
