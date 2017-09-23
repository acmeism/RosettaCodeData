echo Quotes are optional in most cases.
echo
echo 'But they are when using either of these characters (or whitespace):'
echo '# $ % ^ & * ( ) { } ; \' " \\ < > ?'
echo
echo Single quotes only interpolate \\ and \' sequences.
echo '\In \other \cases, \backslashes \are \preserved \literally.'
echo
set something variable
echo "Double quotes interpolates \\, \" and \$ sequences and $something accesses."
