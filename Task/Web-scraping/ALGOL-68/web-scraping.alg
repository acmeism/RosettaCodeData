STRING
   domain="tycho.usno.navy.mil",
   page="cgi-bin/timer.pl";

STRING # search for the needle in the haystack #
   needle = "UTC",
   hay stack = "http://"+domain+"/"+page,

   re success="^HTTP/[0-9.]* 200",
   re result description="^HTTP/[0-9.]* [0-9]+ [a-zA-Z ]*",
   re doctype ="\s\s<![Dd][Oo][Cc][Tt][Yy][Pp][Ee] [^>]+>\s+";

PROC raise error = (STRING msg)VOID: ( put(stand error, (msg, new line)); stop);

PROC is html page = (REF STRING page) BOOL: (
     BOOL out=grep in string(re success, page, NIL, NIL) = 0;
     IF INT start, end;
        grep in string(re result description, page, start, end) = 0
     THEN
        page:=page[end+1:];
        IF grep in string(re doctype, page, start, end) = 0
        THEN page:=page[start+2:]
        ELSE raise error("unknown format retrieving page")
        FI
     ELSE raise error("unknown error retrieving page")
     FI;
     out
);

STRING reply;
INT rc = http content (reply, domain, haystack, 0);
IF rc = 0 AND is html page (reply)
THEN
  STRING line; FILE freply; associate(freply, reply);
  on logical file end(freply, (REF FILE freply)BOOL: (done; SKIP));
  DO
    get(freply,(line, new line));
    IF string in string(needle, NIL, line) THEN print((line, new line)) FI
  OD;
  done: SKIP
ELSE raise error (strerror (rc))
FI
