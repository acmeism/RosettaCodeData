LONG	SET D=""
	FOR X=97:1:122 WRITE D,$C(X) SET D=","
	WRITE !
        QUIT
	;
SHORT	S D=""
	F X=97:1:122 W D,$C(X) S D=","
	W !
        Q
