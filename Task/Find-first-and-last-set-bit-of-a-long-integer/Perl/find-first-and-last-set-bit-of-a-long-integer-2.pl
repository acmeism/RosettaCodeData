sub bi_msb {         # Input should be a Math::BigInt object
  length(shift->as_bin)-3;
}
