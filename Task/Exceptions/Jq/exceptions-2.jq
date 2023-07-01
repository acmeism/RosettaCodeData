def division(a;b):
  def abs: if . < 0 then -. else . end;
  if a == 0 and b == 0 then error("0/0")
  elif b == 0 then error("division by 0")
  elif (a|abs|log) - (b|abs|log) > 700 then error("OOB")
  else a/b
  end;

def test(a;b):
  try division(a;b)
  catch if . == "0/0" then 0
        elif . == "division by 0" then null
        else "\(.): \(a) / \(b)"
        end;
