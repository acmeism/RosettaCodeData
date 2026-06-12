import time
import gmpy2

start_time = time.time()

# Overshoot target 999,999 decimal places then truncate to avoid rounding issues.
pi = str(gmpy2.const_pi(3322000))[:1_000_001]  # +1 for decimal point

end_time = time.time()
assert len(pi) == 1_000_001  # "3." plus 999,999 decimal places
print(f"{pi[:30]} .. {pi[-30:]}")
print(f"In {end_time - start_time:.3} seconds")
