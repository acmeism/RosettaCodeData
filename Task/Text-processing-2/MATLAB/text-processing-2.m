function [val,count] = readdat(configfile)
% READDAT reads readings.txt file
%
% The value of boolean parameters can be tested with
%    exist(parameter,'var')

if nargin<1,
   filename = 'readings.txt';
end;

fid = fopen(filename);
if fid<0, error('cannot open file %s\n',a); end;
[val,count] = fscanf(fid,'%04d-%02d-%02d %f %d %f %d %f %d %f %d %f %d %f %d %f %d %f %d %f %d %f %d %f %d %f %d %f %d %f %d %f %d %f %d %f %d %f %d %f %d %f %d %f %d %f %d %f %d %f %d \n');
fclose(fid);

count = count/51;

if (count<1) || count~=floor(count),
     error('file has incorrect format\n')
end;

val = reshape(val,51,count)';   % make matrix with 51 rows and count columns, then transpose it.

d = datenum(val(:,1:3));	% compute timestamps

printf('The following records are followed by a duplicate:');
dix = find(diff(d)==0)		% check for to consequtive timestamps with zero difference

printf('number of valid records: %i\n ', sum( all( val(:,5:2:end) >= 1, 2) ) );
