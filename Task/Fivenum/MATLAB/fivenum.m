function r = fivenum(x)
	r = quantile(x,[0:4]/4);
end;
