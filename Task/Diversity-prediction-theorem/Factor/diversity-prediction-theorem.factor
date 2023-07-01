USING: kernel math math.statistics math.vectors prettyprint ;

TUPLE: div avg-err crowd-err diversity ;

: diversity ( x seq -- obj )
    [ n-v dup v* mean ] [ mean swap - sq ]
    [ nip dup mean v-n dup v* mean ] 2tri div boa ;

49 { 48 47 51 } diversity .
49 { 48 47 51 42 } diversity .
