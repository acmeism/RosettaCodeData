function u = urlencoding(s)
	u = '';
	for k = 1:length(s),
		if isalnum(s(k))
			u(end+1) = s(k);
		else
			u=[u,'%',dec2hex(s(k)+0)];
		end; 	
	end
end
