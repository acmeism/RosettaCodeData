function u = langton_ant(n)
	if nargin<1, n=100; end;
	A = sparse(n,n);	% white
	P = [n/2;n/2];	% Positon
	D = 3;	         % index of direction 0-3
	T = [1,0,-1,0;0,1,0,-1];	% 4 directions
	k = 0;
	while (1)
		k = k+1;	
		a = A(P(1),P(2));
		A(P(1),P(2)) = ~a;
		if ( a )
			D = mod(D+1,4);
		else
			D = mod(D-1,4);
		end;
		P = P+T(:,D+1);
		
		if (~mod(k,100)),spy(A);pause(.1);end;  %display after every 100 interations
	end;
end
