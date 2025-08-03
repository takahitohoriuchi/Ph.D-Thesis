$latex = 'platex -kanji=utf8 -synctex=1 -interaction=nonstopmode %O %S';
$dvipdf = 'dvipdfmx -f ptex-ipaex.map %O -o %D %S';
$pdf_mode = 3;
$bibtex = 'pbibtex %O %S';
$pdf_previewer = 'open %S';
$silent = 1;
$max_repeat = 5;
