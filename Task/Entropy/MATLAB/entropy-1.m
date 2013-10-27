function E = entropy(d)
	if ischar(d), d=abs(d); end;
        [Y,I,J] = unique(d); 	
	H = sparse(J,1,1);
	p = full(H(H>0))/length(d);
	E = -sum(p.*log2(p));
end;
