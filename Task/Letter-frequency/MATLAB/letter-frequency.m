function u = letter_frequency(t)
	if ischar(t)
		t = abs(t);
	end;
	A = sparse(t+1,1,1,256,1);
	printf('"%c":%i\n',[find(A)-1,A(A>0)]')
end
