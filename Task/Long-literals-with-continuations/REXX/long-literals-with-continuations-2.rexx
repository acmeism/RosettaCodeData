/*REXX pgm illustrates how to code a list of words  (named chemical elements  */
/*──────────────────────── ordered by their atomic number)  in a list format. */

$=  'hydrogen     helium        lithium     beryllium   boron        carbon'
$=$ 'nitrogen     oxygen        fluorine    neon        sodium       magnesium'
$=$ 'aluminum     silicon       phosphorous sulfur      chlorine     argon'
$=$ 'potassium    calcium       scandium    titanium    vanadium     chromium'
$=$ 'manganese    iron          cobalt      nickel      copper       zinc'
$=$ 'gallium      germanium     arsenic     selenium    bromine      krypton'
$=$ 'rubidium     strontium     yttrium     zirconium   niobium      molybdenum'
$=$ 'technetium   ruthenium     rhodium     palladium   silver       cadmium'
$=$ 'indium       tin           antimony    tellurium   iodine       xenon'
$=$ 'cesium       barium        lanthanum   cerium      praseodymium neodymium'
$=$ 'promethium   samarium      europium    gadolinium  terbium      dysprosium'
$=$ 'holmium      erbium        thulium     ytterbium   lutetium     hafnium'
$=$ 'tantalum     tungsten      rhenium     osmium      iridium      platinum'
$=$ 'gold         mercury       thallium    lead        bismuth      polonium'
$=$ 'astatine     radon         francium    radium      actinium     thorium'
$=$ 'protactinium uranium       neptunium   plutonium   americium    curium'
$=$ 'berkelium    californium   einsteinium fermium     mendelevium  nobelium'
$=$ 'lawrencium   rutherfordium dubnium     seaborgium  bohrium      hassium'
$=$ 'meitnerium   darmstadtium  roentgenium copernicium nihonium     flerovium'
$=$ 'moscovium    livermorium   tennessine  oganesson'

                                          /* [↑]  element list using abutments*/

update= '29Feb2020'                       /*date of the last revision of list.*/
say 'revision date of the list: '  update /*show the date of the last update. */
elements= space($)                        /*elide excess  blanks   in the list*/
#= words(elements)                        /*the  number of elements "  "   "  */
say 'number of elements in the list: ' #  /*show   "     "    "     "  "   "  */
say 'the last element is: '    word($, #) /*stick a fork in it, we're all done*/
