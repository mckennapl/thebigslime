#!/usr/bin/env python3
import feedparser
import urllib.request
import shutil
from datetime import datetime
import os

CURRENT = "/radio/news/current.mp3"
ARCHIVE_DIR = "/radio/news/archive"

os.makedirs(ARCHIVE_DIR, exist_ok=True)

feed = feedparser.parse("https://feeds.npr.org/500005/podcast.xml")
url = feed.entries[0].enclosures[0].href

timestamp = datetime.now().strftime("%Y%m%d_%H%M")
archive_path = f"{ARCHIVE_DIR}/npr-{timestamp}.mp3"

urllib.request.urlretrieve(url, archive_path)
shutil.copy2(archive_path, CURRENT)

print(f"Saved {url} -> {archive_path}")