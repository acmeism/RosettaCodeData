define method factorial (n)
  if (n < 1)
    error("invalid argument");
  else
    reduce1(\*, range(from: 1, to: n))
  end
end method;
