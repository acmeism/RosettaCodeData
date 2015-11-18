$ wait 0::10  ! gives us 10 seconds to get keystrokes into the type-ahead buffer
$ on control_y then $ goto clean
$ set terminal /noecho
$ loop: read /prompt="" /time=0 sys$command /error=clean buffer
$ goto loop
$ clean:
$ set terminal /echo
