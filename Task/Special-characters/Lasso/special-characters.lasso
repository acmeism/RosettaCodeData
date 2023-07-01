#	defined local ie. #mylocal will fail if not defined
$	defined variable ie. $myvar will fail if not defined
=	assignment
:=	assign as return assigned value
?	ternary conditional true ? this
|	ternary else false ? this | that
||	or
&&	and
!	negative operator
{	open capture
}	close capture
=>	specify givenblock / capture
->	invoke method: mytype->mymethod
&  	retarget: mytype->mymethod&  // returns mytype
^	autocollect from capture: {^ 'this will be outputted' ^}
::	tag prefix, ie. ::mytype->gettype // returns myype
::	type constraint, ie. define mymethod(p::integer) => #i * 2
\	escape method: ie. \mymethod->invoke(2)
// comment
/* open comment
*/ close comment
