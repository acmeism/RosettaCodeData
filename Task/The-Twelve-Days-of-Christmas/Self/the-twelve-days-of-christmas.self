(|
parent* = traits oddball.

gifts = (
   'And a partridge in a pear tree' &
   'Two turtle doves' &
   'Three french hens' &
   'Four calling birds' &
   'FIVE GO-OLD RINGS' &
   'Six geese a-laying' &
   'Seven swans a-swimming' &
   'Eight maids a-milking' &
   'Nine ladies dancing' &
   'Ten lords a-leaping' &
   'Eleven pipers piping' &
   'Twelve drummers drumming'
) asSequence.

days = (
   'first' & 'second' & 'third'    & 'fourth'  &
   'fifth' & 'sixth'  & 'seventh'  & 'eighth'  &
   'ninth' & 'tenth'  & 'eleventh' & 'twelfth'
) asSequence.

intro: i = ( 'On the ', (days at: i), ' day of Christmas, my true love gave to me:').
gifts: i = (  i = 0 ifTrue: [sequence copyAddFirst: 'A partridge in a pear tree' ]
                     False: [(gifts slice: 0@(i + 1)) reverse ]).
verse: i = ( ((sequence copyAddFirst: intro: i) addAll: gifts: i) addLast: '' ).
value    = ( (days gather: [|:d. :i| verse: i ]) asSequence joinUsing: '\n' )

|) value printLine
