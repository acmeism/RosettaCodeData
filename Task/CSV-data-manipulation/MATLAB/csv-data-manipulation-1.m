filename='data.csv';
fid = fopen(filename);
header = fgetl(fid);
fclose(fid);
X = dlmread(filename,',',1,0);

fid = fopen('data.out.csv','w+');
fprintf(fid,'%s,sum\n',header);
for k=1:size(X,1),
	fprintf(fid,"%i,",X(k,:));
	fprintf(fid,"%i\n",sum(X(k,:)));
end;
fclose(fid);
