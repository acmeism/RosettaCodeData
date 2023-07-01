import sequtils, strutils

echo "Allowed starting characters for identifiers:"
echo toSeq(IdentStartChars).join()
echo ""
echo "Allowed characters in identifiers:"
echo toSeq(IdentChars).join()
