   N=: 9516311845790656153499716760847001433441357x
   E=: 65537x
   D=: 5617843187844953170308463622230283376298685x

   ] text=: 'Rosetta Code'
Rosetta Code
   ] num=: 256x #. a.i.text
25512506514985639724585018469
   num >: N  NB. check if blocking is necessary (0 means no)
0
   ] enc=: N&|@^&E num
916709442744356653386978770799029131264344
   ] dec=: N&|@^&D enc
25512506514985639724585018469
   ] final=: a. {~ 256x #.inv dec
Rosetta Code
