lcg = LCG::Berkeley.new(1)
p (1..5).map {lcg.rand}
# prints [1103527590, 377401575, 662824084, 1147902781, 2035015474]

lcg = LCG::Microsoft.new(1)
p (1..5).map {lcg.rand}
# prints [41, 18467, 6334, 26500, 19169]
