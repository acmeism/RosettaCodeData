USING: assocs kernel math mirrors prettyprint strings ;

TUPLE: foo
{ bar string }
{ baz string initial: "hi" }
{ baxx integer initial: 50 read-only } ;
C: <foo> foo

"apple" "banana" 200 <foo> <mirror>
[ >alist ] [ object-slots ] bi [ . ] bi@
