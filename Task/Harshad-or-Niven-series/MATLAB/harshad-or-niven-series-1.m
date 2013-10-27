function v = isharshad(n)
	v = isinteger(n) && ~mod(n,sum(num2str(n)-'0'));
end;
