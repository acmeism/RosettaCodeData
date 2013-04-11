#
NOTES=$HOME/notes.txt
if [[ $# -eq 0 ]] ; then
  [[ -r  $NOTES ]] && more $NOTES
else
  date >> $NOTES
  echo "  $*" >> $NOTES
fi
