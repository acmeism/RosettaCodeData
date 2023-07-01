# Creating a random source
rs := RandomSource(IsMersenneTwister);

# Generate a random number between 1 and 10
Random(rs, 1, 10);

# Same with default random source
Random(1, 10);
