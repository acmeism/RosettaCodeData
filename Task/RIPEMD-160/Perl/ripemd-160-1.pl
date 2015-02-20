use Crypt::RIPEMD160;
say unpack "H*", Crypt::RIPEMD160->hash("Rosetta Code");
