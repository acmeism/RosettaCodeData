  function quine()
    fid = fopen([mfilename,'.m']);
    while ~feof(fid)
      printf('%s\n',fgetl(fid));
    end;
    fclose(fid); 	
  end;
