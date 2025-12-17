# $latex = 'platex -kanji=utf8 -synctex=1 -interaction=nonstopmode -output-directory=out %O %S';
# $dvipdf = 'dvipdfmx -f ptex-ipaex.map %O -o out/%D %S';
# $pdf_mode = 3;
# # $bibtex = 'pbibtex -kanji=utf8 out/%B';
# # $bibtex = 'pbibtex -kanji=utf8 out/data';  # 明示的に指定
# $bibtex = 'pbibtex -kanji=utf8 %B';

# # $bibtex = 'pbibtex -kanji=utf8 %O %D/%B';  # %D は out、%B は data
# # $bibtex = 'cd out && pbibtex %B';



# $pdf_previewer = 'open %S';
# $silent = 1;
# $max_repeat = 5;
# $root_filename = 'data.tex';
# $out_dir = "out";
# $force_mode = 1;

# BEGIN {
#   my $texmfhome = $ENV{'TEXMFHOME'} // "";
#   $ENV{'BSTINPUTS'} = ".:$texmfhome:out";
#   $ENV{'BIBINPUTS'} = ".:$texmfhome:out";
# }


# 出力先
$aux_dir = 'out';
$out_dir = 'out';

# 本体：upLaTeX
$latex = 'uplatex -synctex=1 -interaction=nonstopmode %O %S';

# BibTeX：Unicode前提の upbibtex を使う
$bibtex = 'upbibtex %O %B';
# ↑ data.aux は out/ に出ますが、latexmk が out/ を見に行くので %B でOK
#   （%B は拡張子なしのベース名。latexmk が aux_dir/out_dir を面倒見ます）

# dvipdfmx：PDFバージョン警告を抑える & フォントマップはそのまま
$dvipdf = 'dvipdfmx -V 7 -f ptex-ipaex.map %O -o %D %S';

# 索引（必要なら）
$makeindex = 'mendex %O -U -o %D %S';

$pdf_mode = 3;          # (u)pLaTeX → DVI → dvipdfmx
$silent   = 1;
$max_repeat = 5;
$root_filename = 'data.tex';
$force_mode   = 1;

BEGIN {
  my $texmfhome = $ENV{'TEXMFHOME'} // "";
  # bst/bib の探索パス
  $ENV{'BSTINPUTS'} = ".:$texmfhome:out";
  $ENV{'BIBINPUTS'} = ".:$texmfhome:out";
}
