\ The scratch area provided by PAD is always at least 84 characters in
\ length.  However, READ-LINE may (but does not have to) read up to
\ two line-terminating characters into the buffer after the line, so
\ the buffer size should always be two larger than the limit given to
\ READ-LINE.  Lines that are two long to fit into the buffer will be split,
\ so you can't tell they aren't separate lines.
82 constant max-line

: third ( A b c -- A b c A )
  >r over r> swap ;

: read-lines ( fileid -- fileid )
  begin  pad max-line ( fileid pad max-line )
         third ( fileid pad max-line fileid )
         read-line throw ( fileid chars-read )
  while  pad swap  ( fileid pad chars-read  )  \ string excludes the newline
         type cr
  repeat
  \ Get rid of number of characters read by last call to read-line, which is
  \ zero because no charaters were read.
  drop
;

s" infile.txt" r/o open-file throw   read-lines   close-file throw
