def is_semiprime:
  {i: 2, n: ., nf: 0}
  | until( .i > .n or .result;
      until(.n % .i != 0 or .result;
        if .nf == 2 then .result = 0
        else .nf += 1
        | .n /= .i
        end)
      | .i += 1)
  | if .result == 0 then false else .nf == 2 end;
