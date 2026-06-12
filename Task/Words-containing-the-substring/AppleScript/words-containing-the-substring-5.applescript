local textFile, output
set textFile to ((path to desktop as text) & "unixdict.txt") as «class furl»
-- considering case -- Uncomment this and the corresponding 'end' line for case-sensitive searches.
set output to wordsContaining(textFile, "the", 12)
-- end considering
return {count output, output}
