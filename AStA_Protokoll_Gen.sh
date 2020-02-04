#!/bin/bash

# AStA-Protokoll-Generator
# Copyright 2020 Jonathan Hanser <hanserj@tf.uni-freiburg.de>

# Generate the AStA-Protokoll with pandoc
# Also replace some stuff, like abstimmungen

# Dependencys:
# Latex-Distribution of your liking as long as it has pdf- or lualatex
# pandoc >= 2.6
# optional: emacs >= 26.1

BNAME=$(basename $1 .org)

# Make a copy if something goes wrong
cp $1 $1.bak

# This replaces the results of the polls
# Please be aware that they need to be of the following format:
# (j/n/e) (1/2/3) => Some text that describes the result.
sed -i "s/(j\/n\/e) (\([0-9]*\)\/\([0-9]*\)\/\([0-9]*\)) => \(.*\)/| j | n | e | Ergebnis: |\n| \1 | \2 | \3 | \4 |\n/" $1

# Generate the pdf-output.
pandoc -s $1 $BNAME.pdf

printf 'Bye!'
