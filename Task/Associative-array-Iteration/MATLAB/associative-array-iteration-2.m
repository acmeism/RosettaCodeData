   keys = fieldnames(hash);
   for k=1:length(keys),
        key = keys{k};
        value = hash.(key);     % get value of key
        hash.(key) = -value;    % set value of key
   end;
