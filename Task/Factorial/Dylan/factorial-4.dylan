define method factorial (n)
  if (n < 1)
    error("invalid argument");
  end;
  // Dylan implementations are required to perform tail call optimization so
  // this is equivalent to iteration.
  local method loop (n, total)
          if (n <= 2)
            total
          else
            let next = n - 1;
            loop(next, total * next)
          end
        end;
  loop(n, n)
end method;
