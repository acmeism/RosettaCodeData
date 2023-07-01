function [S,GS]=gss(a)
% Greatest subsequential sum
a =[0;a(:);0]';
ix1 = find(a(2:end) >0 & a(1:end-1) <= 0);
ix2 = find(a(2:end)<=0 & a(1:end-1) > 0);
K = 0;
S = 0;
for k = 1:length(ix1)
	s = sum(a(ix1(k)+1:ix2(k)));
	if (s>S)
		S=s; K=k;
	end;
end;
GS = a(ix1(K)+1:ix2(K));
