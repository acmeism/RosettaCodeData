Symbols = [ [1000, 'M'], [900, 'CM'], [500, 'D'], [400, 'CD'], [100, 'C'], [90, 'XC'], [50, 'L'], [40, 'XL'], [10, 'X'], [9, 'IX'], [5, 'V'], [4, 'IV'], [1, 'I'] ]

def arabic_to_roman(arabic)
  return '' if arabic.zero?
  Symbols.each { |arabic_rep, roman_rep| return roman_rep + arabic_to_roman(arabic - arabic_rep) if arabic >= arabic_rep }
end
