N=~/notes.txt;[[ $# -gt 0 ]] && { date ; echo " $*"; exit 0; }  >> $N || [[ -r $N ]] && cat $N
