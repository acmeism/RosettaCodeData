define method factorial (n)
  if (n < 1)
    error("invalid argument");
  else
    let total = 1;
    for (i from n to 2 by -1)
      total := total * i;
    end;
    total
  end
end method;
