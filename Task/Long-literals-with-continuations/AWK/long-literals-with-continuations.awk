# syntax: GAWK -f LONG_LITERALS_WITH_CONTINUATIONS.AWK
BEGIN {
    ll_using_concatenation() ; ll_info()
    ll_using_continuation() ; ll_info()
    exit(0)
}
function ll_info(  arr,n,x) {
    n = split(str,arr," ")
    printf("version: %s\n",revised)
    printf("number of elements: %d\n",n)
    printf("last element: %s\n",arr[n])
    x = 30
    printf("first & last %d characters: %s & %s\n\n",x,substr(str,1,x),substr(str,length(str)-x))
}
function ll_remove_multiple_spaces(s) {
# all element names were wrapped in one or more spaces for readability and ease of future editing
# they are removed here
    gsub(/\n/," ",s) # AWK95 needs, GAWK & TAWK don't
    while (s ~ /  /) {
      gsub(/  +/," ",s)
    }
    sub(/^ /,"",s)
    sub(/ $/,"",s)
    return(s)
}
function ll_using_concatenation(  s) {
s=s" hydrogen     helium       lithium      beryllium     "
s=s" boron        carbon       nitrogen     oxygen        "
s=s" fluorine     neon         sodium       magnesium     "
s=s" aluminum     silicon      phosphorous  sulfur        "
s=s" chlorine     argon        potassium    calcium       "
s=s" scandium     titanium     vanadium     chromium      "
s=s" manganese    iron         cobalt       nickel        "
s=s" copper       zinc         gallium      germanium     "
s=s" arsenic      selenium     bromine      krypton       "
s=s" rubidium     strontium    yttrium      zirconium     "
s=s" niobium      molybdenum   technetium   ruthenium     "
s=s" rhodium      palladium    silver       cadmium       "
s=s" indium       tin          antimony     tellurium     "
s=s" iodine       xenon        cesium       barium        "
s=s" lanthanum    cerium       praseodymium neodymium     "
s=s" promethium   samarium     europium     gadolinium    "
s=s" terbium      dysprosium   holmium      erbium        "
s=s" thulium      ytterbium    lutetium     hafnium       "
s=s" tantalum     tungsten     rhenium      osmium        "
s=s" iridium      platinum     gold         mercury       "
s=s" thallium     lead         bismuth      polonium      "
s=s" astatine     radon        francium     radium        "
s=s" actinium     thorium      protactinium uranium       "
s=s" neptunium    plutonium    americium    curium        "
s=s" berkelium    californium  einsteinium  fermium       "
s=s" mendelevium  nobelium     lawrencium   rutherfordium "
s=s" dubnium      seaborgium   bohrium      hassium       "
s=s" meitnerium   darmstadtium roentgenium  copernicium   "
s=s" nihonium     flerovium    moscovium    livermorium   "
s=s" tennessine   oganesson                               "
    str = ll_remove_multiple_spaces(s)
    revised = "2020-06-30"
}
function ll_using_continuation(  s) {
# works with: AWK95, GAWK 3.1.4, GAWK 5, TAWK
s="\
 hydrogen     helium       lithium      beryllium     \
 boron        carbon       nitrogen     oxygen        \
 fluorine     neon         sodium       magnesium     \
 aluminum     silicon      phosphorous  sulfur        \
 chlorine     argon        potassium    calcium       \
 scandium     titanium     vanadium     chromium      \
 manganese    iron         cobalt       nickel        \
 copper       zinc         gallium      germanium     \
 arsenic      selenium     bromine      krypton       \
 rubidium     strontium    yttrium      zirconium     \
 niobium      molybdenum   technetium   ruthenium     \
 rhodium      palladium    silver       cadmium       \
 indium       tin          antimony     tellurium     \
 iodine       xenon        cesium       barium        \
 lanthanum    cerium       praseodymium neodymium     \
 promethium   samarium     europium     gadolinium    \
 terbium      dysprosium   holmium      erbium        \
 thulium      ytterbium    lutetium     hafnium       \
 tantalum     tungsten     rhenium      osmium        \
 iridium      platinum     gold         mercury       \
 thallium     lead         bismuth      polonium      \
 astatine     radon        francium     radium        \
 actinium     thorium      protactinium uranium       \
 neptunium    plutonium    americium    curium        \
 berkelium    californium  einsteinium  fermium       \
 mendelevium  nobelium     lawrencium   rutherfordium \
 dubnium      seaborgium   bohrium      hassium       \
 meitnerium   darmstadtium roentgenium  copernicium   \
 nihonium     flerovium    moscovium    livermorium   \
 tennessine   oganesson                               \
"
    str = ll_remove_multiple_spaces(s)
    revised = "30JUN2020"
}
