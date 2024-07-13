#

if
  declare NOTES=$HOME/notes.txt
  (($#))
then
  {
    date
    echo "  $*"
  } >> $NOTES
else [[ -r  $NOTES ]] && more $NOTES
fi
