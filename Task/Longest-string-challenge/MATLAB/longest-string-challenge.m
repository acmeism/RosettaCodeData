function longestString(file);
  fid = fopen(file);
  maxlen = 0; L = {};
  while ~feof(fid)
    line = fgetl(fid);
    if (length(line)>maxlen)
      maxlen = length(line);
      L = {line};
    elseif (length(line)==maxlen)
      L{end+1} = line;
    end;
  end;
  fclose(fid);
  disp(L);
end;
