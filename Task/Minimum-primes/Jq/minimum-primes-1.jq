include "is_prime";  # reminder

def Numbers1: [5,45,23,21,67];
def Numbers2: [43,22,78,46,38];
def Numbers3: [9,98,12,54,53];

# Generate primes in range(m;n) provided m>=2
def primes(m; n):
  if m%2 == 0 then primes(m+1;n)
  else range(m; n; 2) | select(is_prime)
  end;
