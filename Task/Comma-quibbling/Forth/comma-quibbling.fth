: read  bl parse ;
: not-empty? ( c-addr u -- c-addr u true | false ) ?dup-if true else drop false then ;
: third-to-last  2rot ;
: second-to-last  2swap ;

: quibble
	." {"
	read read begin read not-empty? while third-to-last type ." , " repeat
	second-to-last not-empty? if type then
	not-empty? if ."  and " type then
	." }" cr ;
	
quibble
quibble ABC
quibble ABC DEF
quibble ABC DEF G H
