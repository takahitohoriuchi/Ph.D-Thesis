##################
# movをmp4に変換する
#################

# TODO:圧縮処理もこの前にいれたほうがよい
mkdir -p ./movies/mp4
for f in ./movies/*.mov; do
  [ -f "$f" ] || continue  # movファイルがないときにスキップ
  filename=$(basename "$f" .mov)
  ffmpeg -i "$f" -vcodec libx264 -crf 24 -pix_fmt yuv420p -movflags +faststart "./movies/mp4/${filename}.mp4"
done
