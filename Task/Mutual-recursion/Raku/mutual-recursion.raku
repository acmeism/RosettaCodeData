multi F(0) { 1 }; multi M(0) { 0 }
multi F(\𝑛) { 𝑛 - M(F(𝑛 - 1)) }
multi M(\𝑛) { 𝑛 - F(M(𝑛 - 1)) }

say map &F, ^20;
say map &M, ^20;
