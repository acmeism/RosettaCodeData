  function str = stripchars(str, charlist)
    charlist = unique(charlist);
    for k=1:length(charlist)
      str(str==charlist(k)) = [];
    end;
  end;
