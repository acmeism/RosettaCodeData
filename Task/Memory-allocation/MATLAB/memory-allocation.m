   A = zeros(1000); 	% allocates memory for a 1000x1000 double precision matrix.
   clear A;		% deallocates memory

   b = zeros(1,100000);	% pre-allocate memory to improve performance
   for k=1:100000,
	b(k) = 5*k*k-3*k+2;
   end
