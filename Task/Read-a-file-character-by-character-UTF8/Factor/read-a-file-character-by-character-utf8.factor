USING: kernel io io.encodings.utf8 io.files strings ;
IN: rosetta-code.read-one

"input.txt" utf8 [
    [ read1 dup ] [ 1string write ] while drop
] with-file-reader
