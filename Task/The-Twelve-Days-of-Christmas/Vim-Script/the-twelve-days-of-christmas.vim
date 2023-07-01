let b:days=["first",   "second", "third", "fourth", "fifth",    "sixth",
  \         "seventh", "eighth", "ninth", "tenth",  "eleventh", "twelfth"]

let b:gifts=[
  \ "And a partridge in a pear tree.",
  \ "Two turtle doves,",
  \ "Three french hens,",
  \ "Four calling birds,",
  \ "Five golden rings,",
  \ "Six geese a-laying,",
  \ "Seven swans a-swimming,",
  \ "Eight maids a-milking,",
  \ "Nine ladies dancing,",
  \ "Ten lords a-leaping,",
  \ "Eleven pipers piping,",
  \ "Twelve drummers drumming,"
\ ]

function Nth(n)
  echom "On the " . b:days[a:n] . " day of Christmas, my true love gave to me:"
endfunction

call Nth(0)
echom toupper(strpart(b:gifts[0], 4, 1)) . strpart(b:gifts[0], 5)

let b:day = 1
while (b:day < 12)
  echom " "
  call Nth(b:day)
  let b:gift = b:day
  while (b:gift >= 0)
    echom b:gifts[b:gift]
    let b:gift = b:gift - 1
  endwhile
  let b:day = b:day + 1
endwhile
