  fid = fopen('filename','r');
  [str,count] = fread(fid, [1,inf], 'uint8=>char');  % s will be a character array, count has the number of bytes
  fclose(fid);
