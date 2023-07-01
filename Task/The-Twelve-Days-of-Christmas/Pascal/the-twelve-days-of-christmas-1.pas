program twelve_days(output);

const
  days:  array[1..12] of string =
    ( 'first',   'second', 'third', 'fourth', 'fifth',    'sixth',
      'seventh', 'eighth', 'ninth', 'tenth',  'eleventh', 'twelfth' );

  gifts: array[1..12] of string =
    ( 'A partridge in a pear tree.',
      'Two turtle doves and',
      'Three French hens,',
      'Four calling birds,',
      'Five gold rings,',
      'Six geese a-laying,',
      'Seven swans a-swimming,',
      'Eight maids a-milking,',
      'Nine ladies dancing,',
      'Ten lords a-leaping,',
      'Eleven pipers piping,',
      'Twelve drummers drumming,' );

var
   day, gift: integer;

begin
   for day := 1 to 12 do begin
     writeln('On the ', days[day], ' day of Christmas, my true love sent to me:');
     for gift := day downto 1 do
       writeln(gifts[gift]);
     writeln
   end
end.
