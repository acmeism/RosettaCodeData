def subset(A;B):
  # TCO
  def _subset:
    if .[0]|length == 0 then true
    elif .[1]|length == 0 then false
    elif .[0][0] == .[1][0] then [.[0][1:], .[1][1:]] | _subset
    elif .[0][0] < .[1][0] then false
    else [ .[0], .[1][1:] ] | _subset
    end;
  [A,B] | _subset;
