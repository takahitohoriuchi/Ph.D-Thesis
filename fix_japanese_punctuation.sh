#!/bin/bash

INPUT="$1"
TMPFILE="$(mktemp)"

# UTF-8で処理（念のためiconvでエンコーディング統一）
iconv -f UTF-8 -t UTF-8 "$INPUT" | \
  sed -e 's/,/、/g' \
      -e 's/，/、/g' \
      -e 's/\./。/g' \
      -e 's/．/。/g' \
      -e 's/｡/。/g' \
  | perl -CSDA -pe '
      # 日本語文字に挟まれた半角スペースを削除
      s/([\p{Hiragana}\p{Katakana}\p{Han}])\x{20,}([\p{Hiragana}\p{Katakana}\p{Han}])/$1$2/g;
  ' > "$TMPFILE"

# 上書き
mv "$TMPFILE" "$INPUT"
