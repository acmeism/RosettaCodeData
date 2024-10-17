def recurse [] { recurse }

try { recurse } catch {|err| print $err.msg }
