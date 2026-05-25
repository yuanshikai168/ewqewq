#!/bin/bash
set -e

echo "Starting Telegram Bot..."

# 初始化数据库（带重试）
python3 -c "
import time
from main import init_database
for i in range(30):
    try:
        init_database()
        print('Database initialized')
        break
    except Exception as e:
        print(f'DB init retry {i+1}/30: {e}')
        time.sleep(3)
"

# 启动应用
cd /app
exec gunicorn main:app --bind 0.0.0.0:${PORT:-8080} --workers 1 --threads 2 --worker-class sync --timeout 120