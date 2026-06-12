USING: kernel math math.functions math.ranges math.text.utils
math.vectors prettyprint sequences ;

2 9 5 ^ 6 * [a,b] [ dup 1 digit-groups 5 v^n sum = ] filter sum .
