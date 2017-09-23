function str = stripchars(str, charlist)
  % MATLAB after 2016b: str = erase(str, charlist);
  str(ismember(str, charlist)) = '';
