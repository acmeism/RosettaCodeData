  % add a new directory at the end of the path
  path(path,newdir);
  addpath(newdir,'-end');  % same as before

  % add a new directory at the beginning
  addpath(newdir);
  path(newdir,path);       % same as before
