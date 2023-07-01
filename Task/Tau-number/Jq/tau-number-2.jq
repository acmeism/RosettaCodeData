def taus: range(1;infinite) | select(. % count(divisors) == 0);

# The first 100 Tau numbers:
[limit(100; taus)]
| nwise(10) | map(lpad(4)) | join(" ")
