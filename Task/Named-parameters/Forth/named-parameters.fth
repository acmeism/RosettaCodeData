256 buffer: first-name
256 buffer: last-name
: is ( a "name" -- )  parse-name rot place ;

: greet ( -- )
  cr ." Hello, " first-name count type space  last-name count type ." !" ;

first-name is Bob  last-name is Hall  greet


require mini-oof2.fs
require string.fs
object class
  field: given-name
  field: surname
end-class Person

: hiya ( -- )
  cr ." Hiya, " given-name $. space surname $. ." !" ;

Person new >o s" Bob" given-name $!  s" Hall" surname $!  hiya o>
