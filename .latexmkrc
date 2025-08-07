$latex = 'platex -kanji=utf8 -synctex=1 -interaction=nonstopmode -output-directory=out %O %S';
$dvipdf = 'dvipdfmx -f ptex-ipaex.map %O -o out/%D %S';
$pdf_mode = 3;
# $bibtex = 'pbibtex -kanji=utf8 out/%B';
# $bibtex = 'pbibtex -kanji=utf8 out/data';  # 明示的に指定
$bibtex = 'pbibtex -kanji=utf8 %B';

# $bibtex = 'pbibtex -kanji=utf8 %O %D/%B';  # %D は out、%B は data
# $bibtex = 'cd out && pbibtex %B';



$pdf_previewer = 'open %S';
$silent = 1;
$max_repeat = 5;
$root_filename = 'data.tex';
$out_dir = "out";
$force_mode = 1;

BEGIN {
  my $texmfhome = $ENV{'TEXMFHOME'} // "";
  $ENV{'BSTINPUTS'} = ".:$texmfhome:out";
  $ENV{'BIBINPUTS'} = ".:$texmfhome:out";
}
