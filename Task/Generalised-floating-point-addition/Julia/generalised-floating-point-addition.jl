@assert(big"12345679e63" * BigFloat(81) + big"1e63" == big"1.0e+72")
@assert(big"12345679012345679e54" * BigFloat(81) + big"1e54" == big"1.0e+72")
@assert(big"12345679012345679012345679e45" * BigFloat(81) + big"1e45" == big"1.0e+72")
@assert(big"12345679012345679012345679012345679e36" * BigFloat(81) + big"1e36" == big"1.0e+72")
