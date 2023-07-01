use Prime::Factor;

say "$_ = {(.&prime-factors || 1).join: ' x ' }" for flat 1 .. 10, 10**20 .. 10**20 + 10;
