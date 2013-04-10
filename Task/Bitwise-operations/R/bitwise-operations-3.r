library(bitops)
bitAnd(35, 42)          # 34
bitOr(35, 42)           # 43
bitXor(35, 42)          # 9
bitFlip(35, bitWidth=8) # 220
bitShiftL(35, 1)        # 70
bitShiftR(35, 1)        # 17
# Note that no bit rotation is provided in this package
