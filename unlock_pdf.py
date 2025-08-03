import pikepdf

input_pdf = "mythesis.pdf"        # ← ここを該当ファイル名に書き換えて
output_pdf = "unlocked_mythesis.pdf"     # 出力ファイル名

# パーミッション付きPDFを開いて再保存（中身は変えない）
with pikepdf.open(input_pdf) as pdf:
    pdf.save(output_pdf)

print("解除完了！")
