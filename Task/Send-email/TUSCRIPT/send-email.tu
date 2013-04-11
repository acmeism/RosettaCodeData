$$ MODE TUSCRIPT

system=SYSTEM ()

IF (system=="WIN") THEN
SET to="name@domain.org"
SET cc="name@domain.net"
subject="test"
text=*
DATA how are you?

status = SEND_MAIL (to,cc,subject,text,-)

ENDIF
