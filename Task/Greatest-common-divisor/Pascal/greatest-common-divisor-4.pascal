Program GreatestCommonDivisorDemo(output);
begin
  writeln ('GCD(', 49865, ', ', 69811, '): ', gcd_iterative(49865, 69811), ' (iterative)');
  writeln ('GCD(', 49865, ', ', 69811, '): ', gcd_recursive(49865, 69811), ' (recursive)');
  writeln ('GCD(', 49865, ', ', 69811, '): ', gcd_binary   (49865, 69811), ' (binary)');
end.
