use Math::BaseCnv 'cnv';
print cnv("1a", 16, 10),"\n";    # "1a" from hex to decimal prints 26
print lc(cnv(26, 10, 16)),"\n";  # 26 from decimal to hex prints "1a"
