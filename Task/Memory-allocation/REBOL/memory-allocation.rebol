Rebol [
    title: "Rosetta code: Memory allocation"
    file:  %Memory_allocation.r3
    url:   https://rosettacode.org/wiki/Memory_allocation
]

recycle/pools
print ["Memory used:" stats]
print "Allocate block for 1'000'000 values..."
blk: make block! 1'000'000
print ["Memory used:" stats]
print "Release the block."
blk: none
recycle
print ["Memory used:" stats]
print "^/Display internal memory info:"
stats/show
