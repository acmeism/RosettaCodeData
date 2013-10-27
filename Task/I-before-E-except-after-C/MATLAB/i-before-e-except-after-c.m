function i_before_e_except_after_c(f)

fid = fopen(f,'r');
nei = 0;
cei = 0;
nie = 0;
cie = 0;
while ~feof(fid)
	c = strsplit(strtrim(fgetl(fid)),char([9,32]));
	if length(c) > 2,
		n = str2num(c{3});
	else
		n = 1;
	end;
	if strfind(c{1},'ei')>1, nei=nei+n; end;
	if strfind(c{1},'cei'),  cei=cei+n; end;
	if strfind(c{1},'ie')>1, nie=nie+n; end;
	if strfind(c{1},'cie'),  cie=cie+n; end;
end;
fclose(fid);

printf('cie: %i\nnie: %i\ncei: %i\nnei: %i\n',cie,nie-cie,cei,nei-cei);
v = '';
if (nie < 3 * cie)
	v=' not';
end
printf('I before E when not preceded by C: is%s plausible\n',v);
v = '';
if (nei > 3 * cei)
	v=' not';
end
printf('E before I when preceded by C: is%s plausible\n',v);
