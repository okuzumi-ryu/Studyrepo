import os
import requests
from bs4 import BeautifulSoup
from datetime import datetime
from Hinata_Member_vars import Hinata_Member_Map

### Variables
BASE_URL = "https://www.hinatazaka46.com/s/official/diary/member/list?ima=0000"
SAVE_ROOT = "./hinata_blog"
TARGET_MEMBER_KEY = "MATSUO_SAKURA"
MEMBER_NAME = Hinata_Member_Map[TARGET_MEMBER_KEY]["Name"]
TARGET_MEMBER_CT = Hinata_Member_Map[TARGET_MEMBER_KEY]["CT"]
TIMEOUT = 10
page = 0
total_images = 0
saved_images = 0

### Main Scraper
os.makedirs(os.path.join(SAVE_ROOT, MEMBER_NAME), exist_ok=True)
print(f"=== {MEMBER_NAME} のブログ画像取得開始 ===")

while True:
    url = f"{BASE_URL}&page={page}&ct={TARGET_MEMBER_CT}"
    print(f"[PAGE {page}] {url}")

    res = requests.get(url, headers={"User-Agent": "Mozilla/5.0"}, timeout=TIMEOUT)
    soup = BeautifulSoup(res.text, "html.parser")

    articles = soup.select("div.p-blog-group div.p-blog-article")
    print(f"取得した記事数: {len(articles)}")

    if not articles:
        print("記事なし → 終了します。")
        break

    for article in articles:
        date_el = article.select_one("div.c-blog-article__date")
        title_el = article.select_one("div.c-blog-article__title")
        img_tags = article.select("img")

        date_text = date_el.text.strip() if date_el else "unknown"
        title_text = title_el.text.strip() if title_el else "no_title"

        # 日付フォルダ作成（例: 202510）
        date_folder = datetime.strptime(date_text, "%Y.%m.%d %H:%M").strftime("%Y%m")
        save_dir = os.path.join(SAVE_ROOT, MEMBER_NAME, date_folder)
        os.makedirs(save_dir, exist_ok=True)

        for img in img_tags:
            img_url = img.get("src")
            if not img_url:
                continue
            
            img_name = os.path.basename(img_url.split("?")[0])
            img_path = os.path.join(save_dir, img_name)
            if os.path.exists(img_path):
                print(f"既に保存済み： {img_name}")
                saved_images += 1
                continue
            
            try:
                with open(img_path, "wb") as f:
                    f.write(requests.get(img_url).content)
                total_images += 1
                print(f"保存成功: {img_name}")
            except requests.RequestException as e:
                print(f"画像ダウンロード失敗: {img_url}({e})")
    page += 1

print(f"""\
========== 結果 ==========
合計 {total_images} 枚新規保存
既に {saved_images} 枚保存済み
==========================""")
