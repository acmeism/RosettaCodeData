require 'strings'  NB. not necessary for versions > j6

days=: ;:'first second third fourth fifth sixth seventh eighth ninth tenth eleventh twelfth'

gifts=: <;.2 ] 0 : 0
And a partridge in a pear tree.
Two turtle doves,
Three french hens,
Four calling birds,
Five golden rings,
Six geese a-laying,
Seven swans a-swimming,
Eight maids a-milking,
Nine ladies dancing,
Ten lords a-leaping,
Eleven pipers piping,
Twelve drummers drumming,
)

firstline=: 'On the ' , ,&(' day of Christmas, my true love gave to me',LF)

chgFirstVerse=: rplc&('nd a';'')&.>@{. , }.

makeVerses=: [: chgFirstVerse (firstline&.> days) ,&.> [: <@;@|.\ gifts"_

singCarol=: LF joinstring makeVerses
