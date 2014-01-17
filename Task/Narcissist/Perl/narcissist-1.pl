# this is file narc.pl
local $/;
print do { open 0; <0> } eq <> ? "accept" : "reject";
