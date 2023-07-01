function out = fizzbuzzS()
	nums = [3, 5];
	words = {'fizz', 'buzz'};
	for (n=1:100)
		tempstr = '';
		for (i = 1:2)
			if mod(n,nums(i))==0
				tempstr = [tempstr,  words{i}];
			end
		end
		if length(tempstr) == 0
			disp(n);
		else
			disp(tempstr);
		end
	end
end
