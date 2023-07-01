include lib/yield.4th

: spin 8 emit emit sync ;              ( c --)

: spinner                              ( --)
  begin
    [char] | spin yield [char] / spin yield
    [char] - spin yield [char] \ spin yield
  again
;
                                       ( n -- n+1 f)
: payload 10000000 0 do loop dup 1+ swap 100 < ;
                                       \ dummy task
: test
  ." Wait for it.. " spinner 0         \ start coroutine
  begin payload while yield repeat     \ show spinner while doing it
  drop grab bl spin cr                 \ grab control, finish spinner
  ." Done!" cr                         \ all done
;

test
