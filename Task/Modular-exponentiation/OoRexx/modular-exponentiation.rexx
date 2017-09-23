/* Modular exponentiation */

numeric digits 100
say powerMod(,
 2988348162058574136915891421498819466320163312926952423791023078876139,,
 2351399303373464486466122544523690094744975233415544072992656881240319,,
 1e40)
exit

powerMod: procedure

use strict arg base, exponent, modulus

exponent=exponent~d2x~x2b~strip('L','0')
result=1
base = base // modulus
do exponentPos=exponent~length to 1 by -1
  if (exponent~subChar(exponentPos) == '1')
    then result = (result * base) // modulus
  base = (base * base) // modulus
end
return result
