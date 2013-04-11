sub isprime {
  ('1' x shift) !~ /^1?$|^(11+?)\1+$/
}

# A quick test
print join(', ', grep(isprime($_), 0..39)), "\n";
