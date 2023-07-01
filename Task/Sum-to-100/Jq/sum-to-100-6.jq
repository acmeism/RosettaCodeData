def first_missing(s):
    first( foreach s as $i (null;
           if . == null or $i == . or $i == .+1 then $i else [.+1] end;
           select(type == "array") | .[0]));

first_missing( [generate(9) | addup | select(.>0) ] | unique[])
