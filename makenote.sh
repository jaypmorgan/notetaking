#!/bin/bash

while getopts ":lo" option; do
    case $option in
        l) FILE_TYPE=1 >&2;;
        o) FILE_TYPE=0 >&2;;
	j) FILE_TYPE=2 >&2;;
        :) echo "You must specify latex, org mode, julia markdown with flags: [-l -o -j]";;
    esac
done

printf 'Title: '
read TITLE
FILE_TITLE=$(sed 's|\s|-|g' <<< $TITLE)
DATE=$(date --iso-8601='date')

latex () {
    # create a latex file
    FILENAME="$DATE-$FILE_TITLE.tex"

    touch "$FILENAME"
    echo """\\documentclass[a4paper]{article}
\\usepackage{includes/fancyNotes}
\\title{$TITLE}
\\begin{document}


\\end{document}""" >> "$FILENAME"
}

orgMode () {
   # create an ORG-mode file
    FILENAME="$DATE-$FILE_TITLE.org"

    touch "$FILENAME"
    echo """#+TITLE:
#+LATEX_CLASS: article
#+LATEX_HEADER: \title{$TITLE}
#+LATEX_HEADER: \usepackage{includes/fancyNotes}
#+LATEX_HEADER: \renewcommand\maketitle{}
#+LATEX_COMPILER: tectonic
#+OPTIONS: toc:nil author:nil date:nil

    """ >> "$FILENAME"
}

juliaMarkdown() {
    FILENAME="$DATE-$FILE_TITLE.jmd"
    touch "$FILENAME"
    echo """---
title : $TITLE
date : $DATE
template : fancyNotes.tpl
---

""" >> "$FILENAME"
}

if [[ $FILE_TYPE == 1 ]]; then
    latex
fi
if [[ $FILE_TYPE == 0 ]]; then
    orgMode
fi

if [[ $FILE_TYPE == 2 ]]; then
    juliaMarkdown
fi
