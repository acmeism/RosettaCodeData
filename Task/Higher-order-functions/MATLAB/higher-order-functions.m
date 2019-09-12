   F1=@sin;	% F1 refers to function sin()
   F2=@cos;	% F2 refers to function cos()

   % varios ways to call the referred function 	
   F1(pi/4)
   F2(pi/4)
   feval(@sin,pi/4)
   feval(@cos,pi/4)
   feval(F1,pi/4)
   feval(F2,pi/4)

   % named functions, stored as strings	
   feval('sin',pi/4)
   feval('cos',pi/4)
   F3 = 'sin';
   F4 = 'cos';
   feval(F3,pi/4)
   feval(F4,pi/4)
