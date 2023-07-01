  eln = 7;  % extract line number 7
  line = '';
  fid = fopen('foobar.txt','r');
  if (fid < 0)
	printf('Error:could not open file\n')
  else
        n = 0;
	while ~feof(fid),
              n = n + 1;
              if (n ~= eln),
                    fgetl(fid);
              else
                    line = fgetl(fid);
              end
	end;
        fclose(fid);
  end;
  printf('line %i: %s\n',eln,line);
