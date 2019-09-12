/*REXX program searches a collection of strings   (an array of periodic table elements).*/
    /*───────────────names of the first 200 elements of the periodic table.─────────────*/
_=  'hydrogen helium lithium beryllium boron carbon nitrogen oxygen fluorine neon sodium'
_=_ 'magnesium aluminum silicon phosphorous sulfur chlorine argon potassium calcium'
_=_ 'scandium titanium vanadium chromium manganese iron cobalt nickel copper zinc'
_=_ 'gallium germanium arsenic selenium bromine krypton rubidium strontium yttrium'
_=_ 'zirconium niobium molybdenum technetium ruthenium rhodium palladium silver cadmium'
_=_ 'indium tin antimony tellurium iodine xenon cesium barium lanthanum cerium'
_=_ 'praseodymium neodymium promethium samarium europium gadolinium terbium dysprosium'
_=_ 'holmium erbium thulium ytterbium lutetium hafnium tantalum tungsten rhenium osmium'
_=_ 'iridium platinum gold mercury thallium lead bismuth polonium astatine radon'
_=_ 'francium radium actinium thorium protactinium uranium neptunium plutonium americium'
_=_ 'curium berkelium californium einsteinium fermium mendelevium nobelium lawrencium'
_=_ 'rutherfordium dubnium seaborgium bohrium hassium meitnerium darmstadtium'
_=_ 'roentgenium copernicium nihonium flerovium moscovium livermorium tennessine'
_=_ 'oganesson ununennium unbinilium unbiunium unbibium unbitrium unbiquadium'
_=_ 'unbipentium unbihexium unbiseptium unbioctium unbiennium untrinilium untriunium'
_=_ 'untribium untritrium untriquadium untripentium untrihexium untriseptium untrioctium'
_=_ 'untriennium unquadnilium unquadunium unquadbium unquadtrium unquadquadium'
_=_ 'unquadpentium unquadhexium unquadseptium unquadoctium unquadennium unpentnilium'
_=_ 'unpentunium unpentbium unpenttrium unpentquadium unpentpentium unpenthexium'
_=_ 'unpentseptium unpentoctium unpentennium unhexnilium unhexunium unhexbium unhextrium'
_=_ 'unhexquadium unhexpentium unhexhexium unhexseptium unhexoctium unhexennium'
_=_ 'unseptnilium unseptunium unseptbium unsepttrium unseptquadium unseptpentium'
_=_ 'unsepthexium unseptseptium unseptoctium unseptennium unoctnilium unoctunium'
_=_ 'unoctbium unocttrium unoctquadium unoctpentium unocthexium unoctseptium unoctoctium'
_=_ 'unoctennium unennilium unennunium unennbium unenntrium unennquadium unennpentium'
_=_ 'unennhexium unennseptium unennoctium unennennium binilnilium'

haystack= _                                      /*assign the elements ───►  haystack.  */
needle  = 'gold'                                 /*we'll be looking for the gold.       */
upper needle haystack                            /*in case some people capitalize stuff.*/
idx= wordpos(needle, haystack)                   /*use REXX's BIF:  WORDPOS             */
if idx\==0  then return idx                      /*return the haystack  index  number.  */
            else say  needle  "wasn't found in the haystack!"
return 0                                         /*indicates the needle  wasn't  found. */
                                                 /*stick a fork in it,  we're all done. */
