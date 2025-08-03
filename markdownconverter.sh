#!/bin/bash

INPUT=./introduction/chapter2.tex

# まず sed で見出し・強調だけ処理
sed -E \
  -e 's/^### (.*)/\\subsubsection{\1}/' \
  -e 's/^## (.*)/\\subsection{\1}/' \
  -e 's/^# (.*)/\\section{\1}/' \
  -e 's/\*\*([^*]+)\*\*/\\textbf{\1}/g' \
  -e 's/\*([^*]+)\*/\\textit{\1}/g' \
  "$INPUT" > tmpfile

# awkで句点改行＆引用/箇条書き環境処理
gawk '
function closeenv() {
  if (inquote) { print "\\end{quote}"; inquote=0 }
  if (initem) { print "\\end{itemize}"; initem=0 }
  if (inenum) { print "\\end{enumerate}"; inenum=0 }
}

{
  line=$0

  # 句点後に改行を挿入（ただし、すでに改行されてるものは除外）
  output=""
  while (match(line, /[。．.]/)) {
    pre=substr(line, 1, RSTART)
    post=substr(line, RSTART+1)

    ch_before = (RSTART > 1) ? substr(line, RSTART-1, 1) : ""
    ch_after  = substr(post,1,1)

    if (substr(pre,length(pre),1) == ".") {
      # ピリオドの場合のみ特別処理
      if (ch_before ~ /[一-龥ぁ-んァ-ン]/) {
        # 日本語の直後のピリオドなら改行
        if (ch_after != "\n" && ch_after != "") {
          output = output pre "\n"
        } else {
          output = output pre
        }
      } else {
        # 英数・パス中のピリオドは改行しない
        output = output pre
      }
    } else {
      # 「。」や「．」は無条件で改行
      if (ch_after != "\n" && ch_after != "") {
        output = output pre "\n"
      } else {
        output = output pre
      }
    }
    line=post
  }
  output = output line
  line=output

  # 空行は連続で出力しない
  if (line ~ /^[[:space:]]*$/) {
    closeenv()
    if (!printed_empty) { print ""; printed_empty=1 }
    next
  }
  printed_empty=0

  # 引用
  if (line ~ /^>/) {
    if (!inquote) { closeenv(); print "\\begin{quote}"; inquote=1 }
    sub(/^>\s*/, "", line)
    print line
    next
  }

  # 箇条書き
  if (line ~ /^- /) {
    if (!initem) { closeenv(); print "\\begin{itemize}"; initem=1 }
    print "\\item " substr(line, 3)
    next
  }
  if (line ~ /^[0-9]+\.[ ]/) {
    if (!inenum) { closeenv(); print "\\begin{enumerate}"; inenum=1 }
    sub(/^[0-9]+\. /, "", line)
    print "\\item " line
    next
  }

  # 普通の行
  closeenv()
  print line
}

END { closeenv() }
' tmpfile > tmpfile2 && mv tmpfile2 "$INPUT"

rm -f tmpfile
