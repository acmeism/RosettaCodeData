string: "the cow goes over the moon"
substring: "cow"
char:"g"
n:2
m:4

"string: "
"the cow goes over the moon"
" "

// without first n  characters with cut _
"without first n (2) characters "
{n_x}string

// without last character ; reverse and remove last then reverse
"without last character"
{|1_|x}"the cow goes over the moon"

// string from char g until end ; find char with where & and then cut
"string from char g until end"
{((&char=x)[0])_x}string

// substring of m  length from character g ; same as above only flatten with ,//
"substring of m (4) length from character g "
{x[,//(&char=x)[0]+ !m]}string

// from substring of length m ; find firstindex of substring; check if substring; checks if the characters are in order with <
"from substring of length m"
firstindex:({&x[0]=string}'(((#substring);1)#substring))[0][0]
issubstring:1=*/(!#substring)= (<{&x[0]=string}'(((#substring);1)#substring))
// if issubstring display; else do nothing
$[issubstring; ({x[firstindex+!m]}string);""]
