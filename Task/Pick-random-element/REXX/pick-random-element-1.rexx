/*REXX program to pick a random element from a list (tongue in cheek). */

_=  'hydrogen helium lithium beryllium boron carbon nitrogen oxygen'
_=_ 'fluorine neon sodium magnesium aluminum silicon phosphorous sulfur'
_=_ 'chlorine argon potassium calcium scandium titanium vanadium chromium'
_=_ 'manganese iron cobalt nickel copper zinc gallium germanium arsenic'
_=_ 'selenium bromine krypton rubidium strontium yttrium zirconium'
_=_ 'niobium molybdenum technetium ruthenium rhodium palladium silver'
_=_ 'cadmium indium tin antimony tellurium iodine xenon cesium barium'
_=_ 'lanthanum cerium praseodymium neodymium promethium samarium europium'
_=_ 'gadolinium terbium dysprosium holmium erbium thulium ytterbium'
_=_ 'lutetium hafnium tantalum tungsten rhenium osmium irdium platinum'
_=_ 'gold mercury thallium lead bismuth polonium astatine radon francium'
_=_ 'radium actinium thorium protactinium uranium neptunium plutonium'
_=_ 'americium curium berkelium californium einsteinum fermium mendelevium'
_=_ 'nobelium lawrencium rutherfordium dubnium seaborgium bohrium hassium'
_=_ 'meitnerium darmstadtium roentgenium copernicium Ununtrium'

w=words(_)
say 'random element =' word(_,random(1,w))
                                       /*stick a fork in it, we're done.*/
