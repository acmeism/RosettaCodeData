set input "a!===b=!=c"
set matchers {"==" "!=" "="}
lassign [multisplit $input $matchers] substrings matchinfo
puts $substrings
puts $matchinfo
