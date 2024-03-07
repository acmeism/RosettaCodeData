ord ← { ⍵ ⌷ 'first' 'second' 'third' 'fourth' 'fifth' 'sixth' 'seventh' 'eighth' 'ninth' 'tenth' 'eleventh' 'twelfth' }

gift ← { ⍵ ⌷ 'A partridge in a pear tree.' 'Two turtle doves, and' 'Three French hens,' 'Four calling birds,' 'Five gold rings,' 'Six geese a-laying,' 'Seven swans a-swimming,' 'Eight maids a-milking,' 'Nine ladies dancing,' 'Ten lords a-leaping,' 'Eleven pipers piping,' 'Twelve drummers drumming,' }

day ← { ⎕ ← (⎕ucs 10),'On the',(ord ⍵),'day of Christmas, my true love sent to me:' ⋄ { ⎕ ← gift ⍵ } ¨ ⌽⍳⍵ }

day ¨ ⍳12
