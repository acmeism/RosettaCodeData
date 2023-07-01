function [n,line] = one_of_n_lines_in_a_file(fn)
fid = fopen(fn,'r');
if fid<0, return; end;
N = 0;
n = 1;
while ~feof(fid)
	N = N+1;
	L = fgetl(fid);
	if (N*rand() < 1)
		n = N;		
		line = L;
	end;
end
fclose(fid);
