define method factorial (n)
  if (n < 1)
    error("invalid argument");
  end;
  local method loop (n)
          if (n <= 2)
            n
          else
            n * loop(n - 1)
          end
        end;
  loop(n)
end method;
