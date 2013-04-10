package require poker

# Increment a memory location; this will probably crash if you try for real.
# We don't define how to get a good address, but it's not usually a problem
# for embedded programming...
set where 0x12340
poke $where [expr {[peek $where] + 1}]
