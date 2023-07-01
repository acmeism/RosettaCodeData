:- use_module(bitmap).
:- use_module(bitmapIO).
:- use_module(library(clpfd)).

% ends when X1 = X2 and Y1 = Y2
draw_recursive_line(NPict,Pict,Color,X,X,_DX,_DY,Y,Y,_E,_Sx,_Sy):-
	set_pixel0(NPict,Pict,[X,Y],Color).
draw_recursive_line(NPict,Pict,Color,X,X2,DX,DY,Y,Y2,E,Sx,Sy):-
	set_pixel0(TPict,Pict,[X,Y],Color),
	E2 #= 2*E,
	% because we can't accumulate error we set Ey or Ex to 1 or 0
	% depending on whether we need to add dY or dX to the error term
	(   E2 >= DY ->
	        Ey = 1, NX #= X + Sx;
	        Ey = 0, NX = X),
	(   E2 =< DX ->
	        Ex = 1, NY #= Y + Sy;
		Ex = 0, NY = Y),
	NE #= E + DX*Ex + DY*Ey,
	draw_recursive_line(NPict,TPict,Color,NX,X2,DX,DY,NY,Y2,NE,Sx,Sy).

draw_line(NPict,Pict,Color,X1,Y1,X2,Y2):-
	DeltaY #= Y2-Y1,
	DeltaX #= X2-X1,
	(   DeltaY < 0 -> Sy = -1; Sy = 1),
	(   DeltaX < 0 -> Sx = -1; Sx = 1),
	DX #= abs(DeltaX),
	DY #= -1*abs(DeltaY),
	E #= DY+DX,
	draw_recursive_line(NPict,Pict,Color,X1,X2,DX,DY,Y1,Y2,E,Sx,Sy).


 init:-
	new_bitmap(B,[100,100],[255,255,255]),
	draw_line(NB,B,[0,0,0],2,2,10,90),
	write_ppm_p6('line.ppm',NB).
