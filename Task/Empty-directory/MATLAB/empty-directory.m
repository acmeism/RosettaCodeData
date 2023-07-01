  function x = isEmptyDirectory(p)
    if isdir(p)		
      f = dir(p)
      x = length(f)>2;
    else
      error('Error: %s is not a directory');
    end;
  end;
