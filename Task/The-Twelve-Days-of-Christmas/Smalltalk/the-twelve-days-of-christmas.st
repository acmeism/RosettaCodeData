Object subclass: TwelveDays [
  Ordinals := #('first'   'second' 'third' 'fourth' 'fifth'    'sixth'
                'seventh' 'eighth' 'ninth' 'tenth'  'eleventh' 'twelfth').

  Gifts := #( 'A partridge in a pear tree.' 'Two turtle doves and'
              'Three French hens,'          'Four calling birds,'
              'Five gold rings,'            'Six geese a-laying,'
              'Seven swans a-swimming,'     'Eight maids a-milking,'
              'Nine ladies dancing,'        'Ten lords a-leaping,'
              'Eleven pipers piping,'       'Twelve drummers drumming,' ).
]

TwelveDays class extend [
  giftsFor: day [
    |newLine ordinal giftList|
    newLine := $<10> asString.
    ordinal := Ordinals at: day.
    giftList := (Gifts first: day) reverse.

    ^'On the ', ordinal, ' day of Christmas, my true love sent to me:',
      newLine, (giftList join: newLine), newLine.
  ]
]

1 to: 12 do: [:i |
  Transcript show: (TwelveDays giftsFor: i); cr.
].
