/*REXX program searches a collection of strings.                        */

haystack=,       /*names of the first 200 elements of the periodic table*/
          'hydrogen helium lithium berylliumbon nitrogen oxygen fluorine neon sodium magnesium aluminum silicon phosphorous sulfur chlorine argon potassium calcium scandium titanium',
          'vanadium chromium manganese iron kel copper zinc gallium germanium arsenic selenium bromine krypton rubidium strontium yttrium zirconium niobium molybdenum technetium ruthenium',
          'rhodium palladium silver cadmium  antimony tellurium iodine xenon cesium barium lanthanum cerium praseodymium neodymium promethium samarium europium gadolinium terbium dysprosium',
          'holmium erbium thulium ytterbium afnium tantalum tungsten rhenium osmium irdium platinum gold mercury thallium lead bismuth polonium astatine radon francium radium actinium',
          'thorium protactinium uranium neptonium americium curium berkelium californium einsteinum fermium mendelevium nobelium lawrencium rutherfordium dubnium seaborgium bohrium hassium',
          'meitnerium darmstadtium roentgenicium ununtrium flerovium ununpentium livermorium ununseptium ununoctium ununennium unbinilium unbiunium unbibium unbitrium unbiquadium',
          'unbipentium unbihexium unbiseptiuum unbiennium untrinilium untriunium untribium untritrium untriquadium untripentium untrihexium untriseptium untrioctium untriennium unquadnilium',
          'unquadunium unquadbium unquadtriuadium unquadpentium unquadhexium unquadseptium unquadoctium unquadennium unpentnilium unpentunium unpentbium unpenttrium unpentquadium',
          'unpentpentium unpenthexium unpentpentoctium unpentennium unhexnilium unhexunium unhexbium unhextrium unhexquadium unhexpentium unhexhexium unhexseptium unhexoctium unhexennium',
          'unseptnilium unseptunium unseptbirium unseptquadium unseptpentium unsepthexium unseptseptium unseptoctium unseptennium unoctnilium unoctunium unoctbium unocttrium unoctquadium',
          'unoctpentium unocthexium unoctsepoctium unoctennium unennilium unennunium unennbium unenntrium unennquadium unennpentium unennhexium unennseptium unennoctium unennennium binilnilium'

needle  = 'gold'                       /*we'll be looking for the gold. */

upper needle haystack                  /*in case some people capitalize.*/

idx=wordpos(needle,haystack)           /*use REXX's bif:  WORDPOS       */
                                       /*       bif:  built-in function.*/
if idx\==0  then return idx            /*return haystack index number.  */
            else say  needle  "wasn't found in the haystack!"
return 0                               /*indicates needle wasn't found. */
