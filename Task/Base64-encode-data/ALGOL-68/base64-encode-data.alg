STRING codes = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"[@0];

PROC get web page = (STRING host, path) STRING:
   BEGIN
      STRING reply;
      INT rc;
      IF rc := tcp request (reply, host,
                               "GET /favicon.ico  HTTP/1.0" + crlf +
                               "Host: rosettacode.org" + crlf +
                               crlf, 80);
            rc = 0 THEN
   SKIP #print (reply)#
      ELSE print (strerror (rc))
      FI;
      IF rc = 0 AND grep in string ("^HTTP/[0-9.]+ 200", reply, NIL, NIL) = 0 THEN
   INT p := 0;
   FOR i TO UPB reply WHILE p = 0 DO
      IF reply[i] = carriage return ANDF reply[i+1] = line feed AND reply[i+2] = carriage return AND reply[i+3] = line feed THEN
         p := i
      FI
   OD;
   IF p /= 0 THEN
      STRING headers = reply[:p],
             body = reply[p+4:];
      body
   ELSE
      ""
   FI
      ELSE
   print (strerror (rc)); ""
      FI
   END;


PROC base64_encode = (STRING s) STRING:
   BEGIN
      STRING result := "";
      BITS u;
      FOR i BY 3 TO UPB s DO
   u := BIN ABS s[i] SHL 16 OR
        IF i+1 <= UPB s THEN BIN ABS s[i+1] SHL 8 OR
           IF i+2 <= UPB s THEN BIN ABS s[i+2]
     ELSE 16r0
                 FI
        ELSE 16r0
        FI;

   result +:= codes[ABS (u SHR 18 AND 16r3f)] +
                    codes[ABS (u SHR 12 AND 16r3f)] +
              (i + 1 <= UPB s | codes[ABS (u SHR 6 AND 16r3f)] | "=") +
        (i + 2 <= UPB s | codes[ABS (u AND 16r3f)] | "=")
      OD;
      result
   END;


CHAR line feed = REPR 10, carriage return = REPR 13;
STRING crlf = carriage return + line feed;
STRING host = "rosettacode.org";

STRING rosettacode icon = get web page (host, "http://rosettacode.org/favicon.ico");
STRING encoded icon = base64_encode (rosettacode icon);
print ((encoded icon, new line))
