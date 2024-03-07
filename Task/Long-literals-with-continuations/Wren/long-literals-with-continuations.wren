import "./pattern" for Pattern

var elementStr =
"""hydrogen     helium        lithium     beryllium   boron        carbon
   nitrogen     oxygen        fluorine    neon        sodium       magnesium
   aluminum     silicon       phosphorous sulfur      chlorine     argon
   potassium    calcium       scandium    titanium    vanadium     chromium
   manganese    iron          cobalt      nickel      copper       zinc
   gallium      germanium     arsenic     selenium    bromine      krypton
   rubidium     strontium     yttrium     zirconium   niobium      molybdenum
   technetium   ruthenium     rhodium     palladium   silver       cadmium
   indium       tin           antimony    tellurium   iodine       xenon
   cesium       barium        lanthanum   cerium      praseodymium neodymium
   promethium   samarium      europium    gadolinium  terbium      dysprosium
   holmium      erbium        thulium     ytterbium   lutetium     hafnium
   tantalum     tungsten      rhenium     osmium      iridium      platinum
   gold         mercury       thallium    lead        bismuth      polonium
   astatine     radon         francium    radium      actinium     thorium
   protactinium uranium       neptunium   plutonium   americium    curium
   berkelium    californium   einsteinium fermium     mendelevium  nobelium
   lawrencium   rutherfordium dubnium     seaborgium  bohrium      hassium
   meitnerium   darmstadtium  roentgenium copernicium nihonium     flerovium
   moscovium    livermorium   tennessine  oganesson"""

var p = Pattern.new("+1/s")           // matches 1 or more whitespace characters
var elements = p.splitAll(elementStr) // get a list of elements
elementStr = elements.join(" ")       // recombine using a single space as separator
var lastUpdate = "2023-12-17"
System.print("Last updated       : %(lastUpdate)")
System.print("Number of elements : %(elements.count)")
System.print("Last element       : %(elements[-1])")
