function walk_a_directory_recursively(d, pattern)
	f = dir(fullfile(d,pattern));
	for k = 1:length(f)
		printf('%s\n',fullfile(d,f(k).name));
	end;

	f = dir(d);
	n = find([f.isdir]);	
	for k=n(:)'
		if any(f(k).name~='.')
			walk_a_directory_recursively(fullfile(d,f(k).name), pattern);
		end;
	end;
end;
