#!/bin/bash

# AStA-Protokoll-Generator
# Copyright 2020 Jonathan Hanser <hanserj@tf.uni-freiburg.de>

# Generate the AStA-Protokoll with pandoc
# Also replace some stuff, like abstimmungen

# Dependencys:
# Latex-Distribution of your liking as long as it has pdf- or lualatex
# pandoc >= 2.6
# optional: emacs >= 26.1

function init {
    # Some initialisation for all the rest.
    BNAME=$(basename $1 .org)
    INPUTFILE=$1

    # Make a copy if something goes wrong
    cp "$INPUTFILE" "$INPUTFILE".bak
}

function replace_results {
    # This replaces the results of the polls
    # Please be aware that they need to be of the following format:
    # (j/n/e) (1/2/3) => Some text that describes the result.
    printf "Die Ergebnisse der Abstimmung werden hübsch gemacht.\n"
    sed -i "s,(j/n/e) (\([0-9]*\)/\([0-9]*\)/\([0-9]*\)) => \(.*\),| j | n | e | Ergebnis: |\n| \1 | \2 | \3 | \4 |\n," "$INPUTFILE"
}

function replace_absences {
    # Streamlining.
    printf "(Un)entschuldigte Abwesenheiten, Neuigkeitenlosigkeit und Nichtbesetzungen werden eingetragen.\n"
    # They just weren't there.
    sed -i "s,- n/a$,- Nicht anwesend.," "$INPUTFILE"
    # They provided a valid reason for not being there.
    sed -i "s,- ent$,- Entschuldigt.," "$INPUTFILE"
    # Not filled position
    sed -i "s,- n/b$,- Nicht besetzt.," "$INPUTFILE"
    # Nothing new to report
    sed -i "s,- n/n$,- Nichts neues.," "$INPUTFILE"
}

function replace_broken_stuff {
    # Helluvalot is fecked.
    # Quotation marks
    sed -i "s,\",''," "$INPUTFILE"
}

function generate_output {
    # Generate the pdf-output with pandoc.
    printf "Das Protokoll wird erstellt...\n"
    pandoc -s $INPUTFILE -o $BNAME.pdf
}

function cleanup {
    true
    # If everythign worked out fine, remove the .bak file from above
    # also open the pdf and ask if everything is alright or rollback
    # Something for the future!
}

# The main!
# Here happens everything!
init $1
replace_broken_stuff
replace_absences
replace_results
generate_output

xdg-open $BNAME.pdf

printf 'Fertig.\nTschüssle!\n'
