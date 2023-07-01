def black: { "red": 0, "green": 0, "blue": 0};
def red: black + { "red": 255 };
def yellow: red + { "green": 255 };

xor_pattern(384; 384; red; yellow)
