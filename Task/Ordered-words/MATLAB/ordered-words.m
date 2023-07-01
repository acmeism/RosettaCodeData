maxlen = 0;
listlen= 0;
fid = fopen('unixdict.txt','r');
while ~feof(fid)
    str = fgetl(fid);
    if any(diff(abs(str))<0) continue; end;

    if length(str)>maxlen,
	list = {str};
	maxlen = length(str);
    elseif length(str)==maxlen,
	list{end+1} = str;
    end;
end
fclose(fid);
printf('%s\n',list{:});
