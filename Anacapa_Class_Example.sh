# EDIT THESE
BASEDIR="/home/truelove" # change to folder you want shared into container
#CONTAINER="/vagrant/anacapa-container/anacapa-1.5.0.img" # change to full container .img path
DB="/home/truelove/anacapa/Anacapa_db" # change to full path to Anacapa_db
OUT="$BASEDIR/12S_time_test" # change to output data folder

cd $BASEDIR

# If you need additional folders shared into the container, add additional -B arguments below
time singularity exec -B $BASEDIR -B $SINGULARITY $CONTAINER /bin/bash -c "$DB/anacapa_classifier.sh -o $OUT -d $DB -l"
The expecte