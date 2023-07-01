STRING domain="rosettacode.org";
STRING page="wiki/Main_Page";

STRING re success="^HTTP/[0-9.]* 200";
STRING re result description="^HTTP/[0-9.]* [0-9]+ [a-zA-Z ]*";
STRING re doctype ="\s\s<!DOCTYPE html PUBLIC ""[^>]+"">\s+";

PROC html page = (REF STRING page) BOOL: (
     BOOL out=grep in string(re success, page, NIL, NIL) = 0;
     IF INT start, end;
        grep in string(re result description, page, start, end) = 0
     THEN
        page:=page[end+1:];
        IF grep in string(re doctype, page, start, end) = 0
        THEN page:=page[start+2:]
        ELSE print ("unknown format retrieving page")
        FI
     ELSE print ("unknown error retrieving page")
     FI;
     out
);

IF STRING reply;
   INT rc =
      http content (reply, domain, "http://"+domain+"/"+page, 0);
   rc = 0 AND html page (reply)
THEN print (reply)
ELSE print (strerror (rc))
FI
