roman: procedure
arg number

/* handle only 1 to 3999, else return ? */
if number >= 4000 | number <= 0 then return "?"

romans = "   M  CM   D  CD   C  XC  L  XL  X IX  V IV  I"
arabic = "1000 900 500 400 100  90 50  40 10  9  5  4  1"

result = ""
do i = 1 to words(romans)
  do while number >= word(arabic,i)
    result = result || word(romans,i)
    number = number - word(arabic,i)
  end
end
return result
