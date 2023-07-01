USING: io.encodings.utf8 io.launcher ;
"echo hello" utf8 [ contents ] with-process-reader .
