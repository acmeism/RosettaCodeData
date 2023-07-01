import sequtils, strutils

echo "Lowercase characters:"
echo toSeq('a'..'z').join()
echo ""
echo "Uppercase characters:"
echo toSeq('A'..'Z').join()
