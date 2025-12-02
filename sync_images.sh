# #!/bin/bash

# # SRC="/Users/takahitohoriuchi/Library/CloudStorage/GoogleDrive-discus4372@keio.jp/マイドライブ/博論images"  # Drive側
# DST="./images"  # 博論プロジェクトのimagesフォルダ

# echo "Starting fswatch + rsync + image->PDF conversion..."

# fswatch -0 "$SRC" | while read -d "" event; do
#   # 連続トリガをまとめるため少し待つ
#   sleep 3
#   echo "Sync triggered at $(date)"

#   # PDFはDriveに戻さない
#   rsync -av --delete --exclude='*.pdf' "$SRC"/ "$DST"/

#   # PNG/JPG/JPEG/HEICをPDFに変換
#   find "$DST" -type f \( \
#     -iname '*.png' -o \
#     -iname '*.jpg' -o \
#     -iname '*.jpeg' -o \
#     -iname '*.heic' \
#   \) | while read img; do
#     pdf="${img%.*}.pdf"
#     # 元画像がPDFより新しい場合のみ再変換
#     if [[ ! -e "$pdf" || "$img" -nt "$pdf" ]]; then
#       echo "Converting: $img -> $pdf"
#       magick "$img" "$pdf"  # ImageMagick 7対応      
#     fi
#   done

#   echo "Sync and image->PDF conversion completed at $(date)"
# done
