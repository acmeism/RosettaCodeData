eval('abs(0)');  # eval("") instead of eval{}; the latter is not for run-time check
print "abs() doesn't seem to be available\n" if $@;
