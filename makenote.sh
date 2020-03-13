#!/bin/bash

printf 'Title: '
read TITLE
TITLE=$(sed 's|\s|-|g' <<< $TITLE)
FILENAME="$(date --iso-8601='date')-$TITLE.tex"
touch "$FILENAME"
echo """\\documentclass[a4paper]{article}
\\usepackage{includes/fancyNotes}

\\title{$TITLE}
\\begin{document}


\\end{document}""" >> "$FILENAME"
vim "$FILENAME"
