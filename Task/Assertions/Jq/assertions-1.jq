def assert(exp; $msg):
  def m: $msg | if type == "string" then . else [.[]] | join(":") end;
  if env.JQ_ASSERT then
    (exp as $e | if $e then . else . as $in | "assertion violation @ \(m) => \($e)" | debug | $in end)
  else . end;

def assert(exp):
  if env.JQ_ASSERT then
    (exp as $e | if $e then . else . as $in | "assertion violation: \($e)" | debug | $in end)
   else . end;

def asserteq(x;y;$msg):
  def m: $msg | if type == "string" then . else [.[]] | join(":") end;
  def s: (if $msg then m + ": " else "" end) + "\(x) != \(y)";
  if env.JQ_ASSERT then
     if x == y then .
     else . as $in | "assertion violation @ \(s)" | debug | $in
     end
   else . end;
