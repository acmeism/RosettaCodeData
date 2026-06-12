def count(s): reduce s as $x (null; .+1);

def emit_until(cond; stream): label $out | stream | if cond then break $out else . end;
