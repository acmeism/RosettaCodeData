      program twelve_days

      character days(12)*8
      data days/'first', 'second', 'third',    'fourth',
     c          'fifth', 'sixth',  'seventh',  'eighth',
     c          'ninth', 'tenth',  'eleventh', 'twelfth'/

      character gifts(12)*27
      data gifts/'A partridge in a pear tree.',
     c           'Two turtle doves and',
     c           'Three French hens,',
     c           'Four calling birds,',
     c           'Five gold rings,',
     c           'Six geese a-laying,',
     c           'Seven swans a-swimming,',
     c           'Eight maids a-milking,',
     c           'Nine ladies dancing,',
     c           'Ten lords a-leaping,',
     c           'Eleven pipers piping,',
     c           'Twelve drummers drumming,'/

      integer day, gift

      do 10 day=1,12
        write (*,'(a)') 'On the ', trim(days(day)),
     c              ' day of Christmas, my true love sent to me:'
        do 20 gift=day,1,-1
          write (*,'(a)') trim(gifts(gift))
  20    continue
        write(*,*)
  10  continue
      end
