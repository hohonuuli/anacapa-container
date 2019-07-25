#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

DB="$DIR/anacapa/Anacapa_db"
DATA="$DIR/anacapa/12S_test_data"
OUT="$DIR/12S_time_test"
FORWARD="$DATA/forward.txt"
REVERSE="$DATA/reverse.txt"

$DB/anacapa_QC_dada2.sh -i $DATA -o $OUT -d $DB -f $FORWARD -r $REVERSE -e $DB/metabarcode_loci_min_merge_length.txt -a truseq -t MiSeq -l -g