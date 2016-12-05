/*REXX program searches a collection of strings   (an array of periodic table elements).*/

haystack=,                                      /*names of the first 200 elements of the periodic table*/
          'hydrogen helium lithium beryllium boron carbon nitrogen oxygen fluorine neon sodium magnesium aluminum silicon phosphorous sulfur chlorine argon potassium calcium scandium titanium',
          'vanadium chromium manganese iron cobalt nickel copper zinc gallium germanium arsenic selenium bromine krypton rubidium strontium yttrium zirconium niobium molybdenum technetium ruthenium',
          'rhodium palladium silver cadmium indium tin antimony tellurium iodine xenon cesium barium lanthanum cerium praseodymium neodymium promethium samarium europium gadolinium terbium dysprosium',
          'holmium erbium thulium ytterbium lutetium hafnium tantalum tungsten rhenium osmium iridium platinum gold mercury thallium lead bismuth polonium astatine radon francium radium actinium',
          'thorium protactinium uranium neptunium plutonium americium curium berkelium californium einsteinium fermium mendelevium nobelium lawrencium rutherfordium dubnium seaborgium bohrium hassium',
          'meitnerium darmstadtium roentgenium copernicium Ununtrium flerovium Ununpentium livermorium Ununseptium Ununoctium Ununennium Unbinilium Unbiunium Unbibium Unbitrium Unbiquadium',
          'Unbipentium Unbihexium Unbiseptium Unbioctium Unbiennium Untrinilium Untriunium Untribium Untritrium Untriquadium Untripentium Untrihexium Untriseptium Untrioctium Untriennium Unquadnilium',
          'Unquadunium Unquadbium Unquadtrium Unquadquadium Unquadpentium Unquadhexium Unquadseptium Unquadoctium Unquadennium Unpentnilium Unpentunium Unpentbium Unpenttrium Unpentquadium',
          'Unpentpentium Unpenthexium Unpentseptium Unpentoctium Unpentennium Unhexnilium Unhexunium Unhexbium Unhextrium Unhexquadium Unhexpentium Unhexhexium Unhexseptium Unhexoctium Unhexennium',
          'Unseptnilium Unseptunium Unseptbium Unsepttrium Unseptquadium Unseptpentium Unsepthexium Unseptseptium Unseptoctium Unseptennium Unoctnilium Unoctunium Niobium Unocttrium Unoctquadium',
          'Unoctpentium Unocthexium Unoctseptium Unoctoctium Unoctennium Unennilium Unennunium Unennbium Unenntrium Unennquadium Unennpentium Unennhexium Unennseptium Unennoctium Unennennium Binilnilium'

needle  = 'gold'                                /*we'll be looking for the gold.        */
upper needle haystack                           /*in case some people capitalize stuff. */
idx=wordpos(needle,haystack)                    /*use REXX's BIF:  WORDPOS              */
if idx\==0  then return idx                     /*return the haystack  index  number.   */
            else say  needle  "wasn't found in the haystack!"
return 0                                        /*indicates the needle  wasn't  found.  */
