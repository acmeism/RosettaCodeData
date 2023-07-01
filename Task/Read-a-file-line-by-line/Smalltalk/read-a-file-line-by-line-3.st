|s|
s := 'foobar.txt' asFilename readStream.
[ s atEnd ] whileFalse:[
    s nextLine printCR.
].
s close
