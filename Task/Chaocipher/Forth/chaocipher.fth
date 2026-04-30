                                       \ triple words
: 3drop drop drop drop ;               ( n1 n2 n3 ---)
: 3dup >r over over r@ rot rot r> ;    ( n1 n2 n3 -- n1 n2 n3 n1 n2 n3)
                                       \ ASCIIZ string words
: zstring create chars allot ;         ( a1 -- a1 n1)
: zcount dup begin dup c@ while char+ repeat over - ;
: zplace over chars over + >r swap cmove 0 r> c! ;
: +zplace zcount chars + zplace ;      ( a1 n1 a2 --)
                                       \ find character in string
: where?                               ( c a1 n1 -- n2)
  0 ?do over over i chars + c@ = if drop i negate leave then loop nip negate ;

64 constant /str                       \ size of input/output string
27 constant /alpha                     \ size of alphabet

/str zstring {i}                       \ input string
/str zstring {o}                       \ output string

/alpha zstring l                       \ left alphabet
/alpha zstring r                       \ right alphabet
/alpha zstring t                       \ temporary alphabet

: [] chars + ;                         ( a n -- a+n)
: .tab 9 emit ;                        ( --)
: .list cr .tab zcount type cr ;       ( a --)

: PermuteLeft                          ( index --)
  26 over ?do t over negate i + [] l i [] c@ swap c! loop
  dup   0 ?do t over negate 26 i + + [] l i [] c@ swap c! loop drop
  t char+ c@ >r t 2 [] dup char- 12 cmove r> t 13 [] c! t zcount l zplace
;

: PermuteRight                         ( index --)
  26 over ?do t over negate i + [] r i [] c@ swap c! loop
  dup   0 ?do t over negate 26 i + + [] r i [] c@ swap c! loop drop
  t c@ >r      t char+ dup char- 25 cmove r> t 25 [] c!
  t 2 [] c@ >r t 3 []  dup char- 11 cmove r> t 13 [] c! t zcount r zplace
;

: Encrypt                              ( input output index1 -- index2)
  >r swap r@ [] c@ r /alpha where? dup 0< abort" Corrupt right alphabet"
  l over [] c@ rot r> [] c!
;

: Decrypt                              ( input output index1 -- index2)
  >r swap r@ [] c@ l /alpha where? dup 0< abort" Corrupt left alphabet"
  r over [] c@ rot r> [] c!
;

: chao                                 ( i o xt f --)
  s" HXUCZVAMDSLKPEFJRIGTWOBNYQ" l zplace
  s" PTLNBQDEOYSFAVZKGJRIHWXUMC" r zplace
  t /alpha erase >r                    \ erase temporary string
                                       ( i o xt R: f)
  r@ if cr ." The left and right alphabets after each permutation:" cr then
  >r over r> swap zcount 1- nip >r     ( i o xt R: f len)

  0 begin                              ( i o xt 0 R: f len)
    r> r@ if l zcount type 2 spaces r zcount type cr then >r
    >r 3dup r@ swap execute r> dup r@ <
  while                                ( i o xt 0 R: f len)
    >r dup PermuteLeft PermuteRight r> 1+
  repeat rdrop rdrop drop drop 3drop
;

: main
  s" WELLDONEISBETTERTHANWELLSAID" {i} zplace
  {o} /str erase                       \ initialize output string

     ." The original plaintext is :"  {i} .list
  {i} {o} ['] Encrypt true  chao
  cr ." The ciphertext is :"          {o} .list
  {o} {i} ['] Decrypt false chao
  cr ." The recovered plaintext is :" {i} .list
;

main
