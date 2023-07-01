import algorithm, sequtils, strutils

const Phrase = "rosetta code phrase reversal"

echo "Phrase:              ", Phrase
echo "Reversed phrase:     ", reversed(Phrase).join()
echo "Reversed words:      ", Phrase.split().mapIt(reversed(it).join()).join(" ")
echo "Reversed word order: ", reversed(Phrase.split()).join(" ")
