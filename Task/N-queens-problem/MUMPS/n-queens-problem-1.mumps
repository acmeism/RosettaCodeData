Queens	New count,flip,row,sol
	Set sol=0
	For row(1)=1:1:4 Do try(2)  ; Not 8, the other 4 are symmetric...
	;
	; Remove symmetric solutions
	Set sol="" For  Set sol=$Order(sol(sol)) Quit:sol=""  Do
	. New xx,yy
	. Kill sol($Translate(sol,12345678,87654321)) ; Vertical flip
	. Kill sol($Reverse(sol)) ; Horizontal flip
	. Set flip="--------" for xx=1:1:8 Do  ; Flip over top left to bottom right diagonal
	. . New nx,ny
	. . Set yy=$Extract(sol,xx),nx=8+1-xx,ny=8+1-yy
	. . Set $Extract(flip,ny)=nx
	. . Quit
	. Kill sol(flip)
	. Set flip="--------" for xx=1:1:8 Do  ; Flip over top right to bottom left diagonal
	. . New nx,ny
	. . Set yy=$Extract(sol,xx),nx=xx,ny=yy
	. . Set $Extract(flip,ny)=nx
	. . Quit
	. Kill sol(flip)
	. Quit
	;
	; Display remaining solutions
	Set count=0,sol="" For  Set sol=$Order(sol(sol)) Quit:sol=""  Do  Quit:sol=""
	. New s1,s2,s3,txt,x,y
	. Set s1=sol,s2=$Order(sol(s1)),s3="" Set:s2'="" s3=$Order(sol(s2))
	. Set txt="+--+--+--+--+--+--+--+--+"
	. Write !,"  ",txt Write:s2'="" " ",txt Write:s3'="" " ",txt
	. For y=8:-1:1 Do
	. . Write !,y," |"
	. . For x=1:1:8 Write $Select($Extract(s1,x)=y:" Q",x+y#2:"  ",1:"##"),"|"
	. . If s2'="" Write " |"
	. . If s2'="" For x=1:1:8 Write $Select($Extract(s2,x)=y:" Q",x+y#2:"  ",1:"##"),"|"
	. . If s3'="" Write " |"
	. . If s3'="" For x=1:1:8 Write $Select($Extract(s3,x)=y:" Q",x+y#2:"  ",1:"##"),"|"
	. . Write !,"  ",txt Write:s2'="" " ",txt Write:s3'="" " ",txt
	. . Quit
	. Set txt="   A  B  C  D  E  F  G  H"
	. Write !,"  ",txt Write:s2'="" " ",txt Write:s3'="" " ",txt Write !
	. Set sol=s3
	. Quit
	Quit
try(col)	New ok,pcol
	If col>8 Do  Quit
	. New out,x
	. Set out="" For x=1:1:8 Set out=out_row(x)
	. Set sol(out)=1
	. Quit
	For row(col)=1:1:8 Do
	. Set ok=1
	. For pcol=1:1:col-1 If row(pcol)=row(col) Set ok=0 Quit
	. Quit:'ok
	. For pcol=1:1:col-1 If col-pcol=$Translate(row(pcol)-row(col),"-") Set ok=0 Quit
	. Quit:'ok
	. Do try(col+1)
	. Quit
	Quit
Do Queens
