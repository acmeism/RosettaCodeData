|utfStream|
utfStream := 'input' asFilename readStream asUTF8EncodedStream.
[utfStream atEnd] whileFalse:[
    Transcript showCR:'got char ',utfStream next.
].
utfStream close.
