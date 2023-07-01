  fid = fopen('/dev/lp0');
  fprintf(fid,'Hello World!\n');
  fclose(fid);
