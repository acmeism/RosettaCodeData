:- use_module(bitmap).
:- use_module(bitmapIO).

write :-
	new_bitmap(AllBlack,[50,50],[0,0,0]),
	set_pixel0(AlmostAllBlack,AllBlack,[25,25],[255,255,255]),
	write_ppm_p6('AlmostAllBlack.ppm',AlmostAllBlack).
