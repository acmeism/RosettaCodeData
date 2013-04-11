// A test
decompose(423)            // Results: List(3,3,47)
decompose(423).product    // Results: 423

// A BigInt test
decompose(BigInt("2535301200456458802993406410752"))
                          // Results: a list of (2)s
decompose(BigInt("2535301200456458802993406410752")).length
                          // Results: 101
decompose(BigInt("2535301200456458802993406410752")).product
                          // Results: 2535301200456458802993406410752
