use_module(library(pce)).
lindraw(X1,Y1,X2,Y2):-
	new(Win,window("Line")),
	new(Pix,pixmap(@nil,black,white,X2+30,Y2+30)),
	send(Win,size,size(400,400)),
	draw_line(Pix,X1,Y1,X2,Y2),
	new(Bmp,bitmap(Pix)),
	send(Win,display,Bmp,point(0,0)),
	send(Win,open).

draw_recursive_line(_Pict,X,X,_DX,_DY,Y,Y,_D,_Sx,_Sy).%Don't iterate if X and X2 are the same number
draw_recursive_line(Pict,X,X2,DX,DY,Y,Y2,C,Sx,Sy):-
	(   C>0->%If the difference is greater than one, add Y one to Y.
	Y1 is Y+Sy,
	    send(Pict,pixel(X,Y1,colour(black))),
	    C2 is C+(2*DY-2*DX);
	Y1 is Y,
	send(Pict,pixel(X,Y,colour(black))),
	    C2 is C+(2*DY)),
	X0 is X+Sx,%The next iteration
	draw_recursive_line(Pict,X0,X2,DX,DY,Y1,Y2,C2,Sx,Sy).
isneg(X,O):-
	(   X<0->

	O is -1;
	(   X\==0->
	O is 1;
	O is 0)).

draw_line(Pict,X1,Y1,X2,Y2):-
	DY is abs(Y2-Y1),
	DX is abs(X2-X1),
	isneg(DX,Sx),
	isneg(DY,Sy),
	D = 2*DY-DX,%The slope of the line
	draw_recursive_line(Pict,X1,X2,DX,DY,Y1,Y2,D,Sx,Sy).
