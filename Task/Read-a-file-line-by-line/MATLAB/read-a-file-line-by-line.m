  fid = fopen('foobar.txt','r');
  if (fid < 0)
	printf('Error:could not open file\n')
  else
	while ~feof(fid),
		line = fgetl(fid);
                %% process line %%
	end;
        fclose(fid)
  end;
