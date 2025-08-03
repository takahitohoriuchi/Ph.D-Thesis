#!/bin/bash

# 現在の日付と時間を取得（例：2025-08-03 14:33）
timestamp=$(date "+%Y-%m-%d %H:%M")

# コミットメッセージを自動生成
message="Auto-commit on $timestamp"

# Gitコマンド実行
git add .
git commit -m "$message"
git push origin main

# 結果を表示
echo "Committed and pushed with message: \"$message\""
