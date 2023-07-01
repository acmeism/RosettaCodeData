NOTES=$HOME/notes.txt
if test "x$*" = "x"
then
        if test -r  $NOTES
        then
                more $NOTES
        fi
else
        date >> $NOTES
        echo "  $*" >> $NOTES
fi
