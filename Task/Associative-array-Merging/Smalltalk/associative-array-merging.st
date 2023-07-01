base := Dictionary withAssociations:{
         'name'-> 'Rocket Skates' .
         'price' -> 12.75 .
         'color' -> 'yellow' }.

update := Dictionary withAssociations:{
         'price' -> 15.25 .
         'color' -> 'red' .
         'year' -> 1974 }.

result := Dictionary new
             declareAllFrom:base;
             declareAllFrom:update.

Transcript showCR: result.
