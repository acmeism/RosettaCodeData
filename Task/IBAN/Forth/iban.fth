include lib/ulcase.4th                 \ for S>UPPER
include lib/triple.4th                 \ for UT/MOD
include lib/cstring.4th                \ for C/STRING
include lib/todbl.4th                  \ for S>DOUBLE

0 constant ud>t                        \ convert unsigned double to triple
88529281 constant 97^4                 \ first stage modulus
char A 10 - negate +constant c>u       \ convert character to IBAN digit

: bank>t u>d rot 3 - 0 ?do 10 mu* loop 1000000000 ut* ;
                                       \ convert country part to unsigned
: country>u                            ( a n -- u)
  c/string c>u 10000 * >r c/string c>u 100 * >r number 100 mod abs r> + r> +
;
                                       \ convert bank part to unsigned
: bank>u                               \ a n -- u)
  c/string c>u 1000000 * >r            \ get first digit and shift
  c/string c>u 10000 * >r              \ get second digit and shift
  c/string c>u 100 * >r                \ get third digit and shift
  drop c@ c>u r> + r> + r> +           \ combine all digits to number
;

: iban>t                               ( a n -- triple)
  s>upper                              \ convert to upper case and get country
  over 4 country>u >r 4 /string        \ get bank part, save length, convert
  over 4 bank>u >r 4 /string tuck s>double
  1000000 mu* r> -rot r> u>d d+ 2>r    \ now assemble everything except bank
  bank>t 2r> ud>t t+                   \ shift bank part and convert to triple
;
                                       ( a n -- f)
: iban? iban>t 97^4 ut/mod 2drop 97 mod 1 = ;
                                       \ perform modulus 97 in two stages
: checkiban                            ( --)
  ." Enter your IBAN: " refill drop 0 parse -trailing iban?
  if ." Valid" else ." Invalid" then cr
;

checkiban
