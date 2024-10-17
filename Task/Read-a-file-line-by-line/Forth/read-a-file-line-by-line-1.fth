\ The scratch area provided by PAD is always at least 84 characters in
\ length.  However, READ-LINE may (but does not have to) read up to
\ two line-terminating characters into the buffer after the line, so
\ the buffer size should always be two larger than the limit given to
\ READ-LINE.  Lines that are too long to fit into the buffer will be
\ split, but if the number of characters read is exactly the buffer
\ size that means the buffer was filled before end of line.  If a line
\ is EXACTLY the length of the buffer it actually takes two READ-LINE
\ calls to read it: the first returns the buffer length as the number
\ of characters read and the second returns zero as the number of
\ characters read.
82 constant max-line

: third ( A b c -- A b c A )
  >r over r> swap ;

: read-lines ( fileid -- fileid )
  begin  pad max-line ( fileid pad max-line )
         third ( fileid pad max-line fileid )
         read-line throw ( fileid chars-read flag )
  while
         \ Save whether it read something other than max-line characters.
         dup max-line <> >r
         pad swap  ( fileid pad chars-read )
         type                           \ Output the line so far.
         r> if cr then                  \ Not max-line characters read, so end line.
  repeat
  \ Get rid of number of characters read by last call to read-line, which is
  \ zero because no charaters were read.
  drop
;

s" infile.txt" r/o open-file throw   read-lines   close-file throw
