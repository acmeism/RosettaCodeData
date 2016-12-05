create ordinals s" first" 2, s" second" 2, s" third"    2, s" fourth" 2,
                s" fifth" 2, s" sixth"  2, s" seventh"  2, s" eighth" 2,
                s" ninth" 2, s" tenth"  2, s" eleventh" 2, s" twelfth" 2,
: ordinal ordinals swap 2 * cells + 2@ ;

create gifts s" A partridge in a pear tree." 2,
             s" Two turtle doves and" 2,
             s" Three French hens," 2,
             s" Four calling birds," 2,
             s" Five gold rings," 2,
             s" Six geese a-laying," 2,
             s" Seven swans a-swimming," 2,
             s" Eight maids a-milking," 2,
             s" Nine ladies dancing," 2,
             s" Ten lords a-leaping," 2,
             s" Eleven pipers piping," 2,
             s" Twelve drummers drumming," 2,
: gift gifts swap 2 * cells + 2@ ;

: day
  s" On the " type
  dup ordinal type
  s"  day of Christmas, my true love sent to me:" type
  cr
  -1 swap -do
    i gift type cr
  1 -loop
  cr
  ;

: main
  12 0 do i day loop
;

main
bye
