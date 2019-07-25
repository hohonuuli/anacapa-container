# EDIT THESE
BASEDIR="/home/truelove" # change to folder you want shared into container
#CONTAINER="/vagrant/anacapa-container/anacapa-1.5.0.img" # change to full container .img path
DB="/home/truelove/anacapa/Anacapa_db" # change to full path to Anacapa_db
DATA="$DB/12S_test_data" # change to input data folder (default 12S_test_data inside Anacapa_db)
OUT="$BASEDIR/12S_time_test" # change to output data folder

# OPTIONAL
FORWARD="$DB/12S_test_data/forward.txt"
REVERSE="$DB/12S_test_data/reverse.txt"

cd $BASEDIR

# If you need additional folders shared into the container, add additional -B arguments below

time singularity exec -B $BASEDIR $CONTAINER /bin/bash -c "$DB/anacapa_QC_dada2.sh -i $DATA -o $OUT -d $DB -f $FORWARD -r $REVERSE -e $DB/metabarcode_loci_min_merge_length.txt -a truseq -t MiSeq -l -g"