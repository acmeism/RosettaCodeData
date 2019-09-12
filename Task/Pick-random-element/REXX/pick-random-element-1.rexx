/*REXX program picks a   random element   from a list   (tongue in cheek, a visual pun).*/
_=  'hydrogen helium lithium beryllium boron carbon nitrogen oxygen fluorine neon sodium'
_=_ 'magnesium aluminum silicon phosphorous sulfur chlorine argon potassium calcium'
_=_ 'scandium titanium vanadium chromium manganese iron cobalt nickel copper zinc gallium'
_=_ 'germanium arsenic selenium bromine krypton rubidium strontium yttrium zirconium'
_=_ 'niobium molybdenum technetium ruthenium rhodium palladium silver cadmium indium tin'
_=_ 'antimony tellurium iodine xenon cesium barium lanthanum cerium praseodymium'
_=_ 'neodymium promethium samarium europium gadolinium terbium dysprosium holmium erbium'
_=_ 'thulium ytterbium lutetium hafnium tantalum tungsten rhenium osmium iridium platinum'
_=_ 'gold mercury thallium lead bismuth polonium astatine radon francium radium actinium'
_=_ 'thorium protactinium uranium neptunium plutonium americium curium berkelium'
_=_ 'californium einsteinium fermium mendelevium nobelium lawrencium rutherfordium dubnium'
_=_ 'seaborgium bohrium hassium meitnerium darmstadtium roentgenium copernicium nihonium'
_=_ 'flerovium moscovium livermorium tennessine oganesson ununenniym unbinvlium umbiunium'

#= words(_)                                      /*obtain the number of words in list.  */
item= subword(_, random(1, #), 1)                /*obtain random word (element) in list.*/
say 'random element: '    item                   /*stick a fork in it,  we're all done. */
