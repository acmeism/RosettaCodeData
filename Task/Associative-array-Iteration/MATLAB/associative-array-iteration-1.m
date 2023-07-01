   keys = fieldnames(hash);
   for k=1:length(keys),
        key = keys{k};
	value = getfield(hash,key);        % get value of key
	hash = setfield(hash,key,-value);  % set value of key
   end;
