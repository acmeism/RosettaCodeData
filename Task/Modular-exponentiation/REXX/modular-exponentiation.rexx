/* REXX  Modular exponentiation */

say powerMod(,
 2988348162058574136915891421498819466320163312926952423791023078876139,,
 2351399303373464486466122544523690094744975233415544072992656881240319,,
 1e40)
return

powerMod: procedure
  parse arg base, exponent, modulus

  /* we need a numeric precision of twice the modulus size,    */
  /* the exponent size, or the base size, whichever is largest */
  numeric digits max(2 * length(format(modulus, , , 0)),,
    length(format(exponent, , , 0)), length(format(base, , , 0)))

  result = 1
  base = base // modulus
  do while exponent > 0
    if exponent // 2 = 1 then
      result = result * base // modulus
    base = base * base // modulus
    exponent = exponent % 2
  end
  return result
