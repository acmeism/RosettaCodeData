USING: io io.encodings.utf8 io.files sequences ;

"rodgers.txt" utf8 file-lines <reversed> [ print ] each
