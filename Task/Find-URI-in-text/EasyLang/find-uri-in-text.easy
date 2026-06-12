schemes$[] = [ "ftp" "gopher" "http" "https" "mailto" "news" "nntp" "telnet" "wais" "file" "prospero" "edit" "tel" "urn" ]
func arrpos s$ a$[] .
   for i to len a$[] : if a$[i] = s$ : return i
   return 0
.
func$[] scan_for_urls text$ .
   lt = len text$
   chidx = 1
   chidx2 = 1
   while chidx2 <= lt
      ch2$ = substr text$ chidx2 1
      c2 = strcode ch2$
      if c2 >= strcode "a" and c2 <= strcode "z"
         if (chidx2 - 1 > chidx) or (strcode substr text$ chidx 1 <= 32)
            chidx = chidx2
         .
         while chidx2 <= lt
            ch2$ = substr text$ chidx2 1
            c2 = strcode ch2$
            if c2 < strcode "a" or c2 > strcode "z" : break 1
            chidx2 += 1
         .
         oneword$ = substr text$ chidx (chidx2 - chidx)
         if chidx2 > lt : break 1
         ch2$ = substr text$ chidx2 1
         if (ch2$ = ":" and arrpos oneword$ schemes$[] > 0) or (ch2$ = "." and oneword$ = "www")
            chidx2 += 1
            chidx0 = chidx2
            isUrl = 0
            bstack$ = ""
            while chidx2 <= lt
               ch2$ = substr text$ chidx2 1
               c2 = strcode ch2$
               if ch2$ = "\"" and chidx2 = chidx0
                  while chidx2 < lt
                     chidx2 += 1
                     ch2$ = substr text$ chidx2 1
                     if ch2$ = "\""
                        chidx2 += 1
                        isUrl = 1
                        break 1
                     .
                  .
                  break 1
               elif strpos "([<{" ch2$ > 0
                  if ch2$ = "("
                     bstack$ &= ")"
                  else
                     bstack$ &= strchar (strcode ch2$ + 2)
                  .
               elif strpos ")]>}" ch2$ > 0
                  if len bstack$ = 0 or substr bstack$ len bstack$ 1 <> ch2$ : break 1
                  bstack$ = substr bstack$ 1 (len bstack$ - 1)
               .
               if c2 <= 32 : break 1
               isUrl = 1
               chidx2 += 1
            .
            if isUrl = 1
               oneurl$ = substr text$ chidx (chidx2 - chidx)
               if len oneurl$ > 0 and substr oneurl$ len oneurl$ 1 = "."
                  oneurl$ = substr oneurl$ 1 (len oneurl$ - 1)
               .
               urls$[] &= oneurl$
            .
            chidx = chidx2
            if chidx2 > lt : break 1
         else
            chidx2 -= 1
         .
      .
      chidx2 += 1
   .
   return urls$[]
.
func$ read .
   repeat
      s$ = input
      until s$ = ""
      txt$ &= s$
      txt$ &= "\n"
   .
   return txt$
.
u$[] = scan_for_urls read
for i = 1 to len u$[] : print u$[i]
#
input_data
this URI contains an illegal character, parentheses and a misplaced full stop:
http://en.wikipedia.org/wiki/Erich_Kästner_(camera_designer). (which is handled by http://mediawiki.org/).
and another one just to confuse the parser: http://en.wikipedia.org/wiki/-)
")" is handled the wrong way by the mediawiki parser.
ftp://domain.name/path(balanced_brackets)/foo.html
ftp://domain.name/path(balanced_brackets)/.ing.in.dot.
ftp://domain.name/path(unbalanced_brackets/.ing.in.dot.
leading junk ftp://domain.name/path/embedded?punct/uation.
leading junk ftp://domain.name/dangling_close_paren)
if you have other interesting URIs for testing, please add them here:
http://www.example.org/foo.html#includes_fragment
http://www.example.org/foo.html#enthält_Unicode-Fragment
 http://192.168.0.1/admin/?hackme=%%%%%%%%%true
blah (foo://domain.hld/))))
https://haxor.ur:4592/~mama/####&?foo
  ftp://ftp.is.co.za/rfc/rfc1808.txt
  http://www.ietf.org/rfc/rfc2396.txt
  mailto:John.Doe@example.com
  news:comp.infosystems.www.servers.unix
  tel:+1-816-555-1212
  telnet://192.0.2.16:80/
  urn:oasis:names:specification:docbook:dtd:xml:4.1.2
