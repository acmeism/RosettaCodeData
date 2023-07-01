def sort_range($a;$b): [range($a;$b)] | sort_by(tostring);

# Example
# jq's index origin is 0, so ...
sort_range(1;14)
