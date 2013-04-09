d := Dictionary new.
'unixdict.txt' asFilename
    readingLinesDo:[:eachWord |
      (d at:eachWord copy sort ifAbsentPut:[OrderedCollection new]) add:eachWord
    ].

((d values select:[:s | s size > 1])
  sortBySelector:#size)
    reverse
      do:[:s | s printCR]
