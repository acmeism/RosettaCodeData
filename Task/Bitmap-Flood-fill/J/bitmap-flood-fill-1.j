NB. finds and labels contiguous areas with the same numbers
NB. ref: http://www.jsoftware.com/pipermail/general/2005-August/023886.html
findcontig=: (|."1@|:@:>. (* * 1&(|.!.0)))^:4^:_@(* >:@i.@$)

NB.*getFloodpoints v Returns points to fill given starting point (x) and image (y)
getFloodpoints=: [: 4&$.@$. [ (] = getPixels) [: findcontig ] -:"1 getPixels

NB.*floodFill v Floods area, defined by point and color (x), of image (y)
NB. x is: 2-item list of (y x) ; (color)
floodFill=: (1&({::)@[ ;~ 0&({::)@[ getFloodpoints ]) setPixels ]
