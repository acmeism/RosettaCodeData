function truncate_a_file(fn,count);

fid=fopen(fn,'r');
s = fread(fid,count,'uint8');
fclose(fid);

fid=fopen(fn,'w');
s = fwrite(fid,s,'uint8');
fclose(fid);
