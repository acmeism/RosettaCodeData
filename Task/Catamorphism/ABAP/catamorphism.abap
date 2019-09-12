report z_catamorphism.

data(numbers) = value int4_table( ( 1 ) ( 2 ) ( 3 ) ( 4 ) ( 5 ) ).

write: |numbers = { reduce string(
  init output = `[`
       index = 1
  for number in numbers
  next output = cond string(
         when index eq lines( numbers )
         then |{ output }, { number } ]|
         when index > 1
         then |{ output }, { number }|
         else |{ output } { number }| )
       index = index + 1 ) }|, /.

write: |sum(numbers) = { reduce int4(
  init result = 0
  for number in numbers
  next result = result + number ) }|, /.

write: |product(numbers) = { reduce int4(
  init result = 1
  for number in numbers
  next result = result * number ) }|, /.

data(strings) = value stringtab( ( `reduce` ) ( `in` ) ( `ABAP` ) ).

write: |strings = { reduce string(
  init output = `[`
       index = 1
  for string in strings
  next output = cond string(
         when index eq lines( strings )
         then |{ output }, { string } ]|
         when index > 1
         then |{ output }, { string }|
         else |{ output } { string }| )
       index = index + 1 ) }|, /.

write: |concatenation(strings) = { reduce string(
  init text = ``
  for string in strings
  next text = |{ text } { string }| ) }|, /.
