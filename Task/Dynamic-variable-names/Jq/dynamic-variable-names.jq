"Enter a variable name:",
(input as $var
 | ("Enter a value:" ,
    (input as $value | { ($var) : $value })))
