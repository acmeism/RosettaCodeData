function [a,g]=agm(a,g)
%%arithmetic_geometric_mean(a,g)
	while (1)
		a0=a;
		a=(a0+g)/2;
		g=sqrt(a0*g);
	if (abs(a0-a) < a*eps) break; end;
	end;
end
