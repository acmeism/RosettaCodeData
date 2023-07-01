import strutils

const RevDate = "2021-02-05"

# We use a long string literal starting and ending with '"""'.
# We eliminate the multiple spaces by using "splitWhiteSpace"
# instead of "split".

const ElementString =
  """
  hydrogen     helium        lithium      beryllium
  boron        carbon        nitrogen     oxygen
  fluorine     neon          sodium       magnesium
  aluminum     silicon       phosphorous  sulfur
  chlorine     argon         potassium    calcium
  scandium     titanium      vanadium     chromium
  manganese    iron          cobalt       nickel
  copper       zinc          gallium      germanium
  arsenic      selenium      bromine      krypton
  rubidium     strontium     yttrium      zirconium
  niobium      molybdenum    technetium   ruthenium
  rhodium      palladium     silver       cadmium
  indium       tin           antimony     tellurium
  iodine       xenon         cesium       barium
  lanthanum    cerium        praseodymium neodymium
  promethium   samarium      europium     gadolinium
  terbium      dysprosium    holmium      erbium
  thulium      ytterbium     lutetium     hafnium
  tantalum     tungsten      rhenium      osmium
  iridium      platinum      gold         mercury
  thallium     lead          bismuth      polonium
  astatine     radon         francium     radium
  actinium     thorium       protactinium uranium
  neptunium    plutonium     americium    curium
  berkelium    californium   einsteinium  fermium
  mendelevium  nobelium      lawrencium   rutherfordium
  dubnium      seaborgium    bohrium      hassium
  meitnerium   darmstadtium  roentgenium  copernicium
  nihonium     flerovium     moscovium    livermorium
  tennessine   oganesson
  """

when isMainModule:

  const ElementList = ElementString.splitWhitespace()

  echo "Last revision date:   ", RevDate
  echo "Number of elements:   ", ElementList.len
  echo "Last element in list: ", ElementList[^1]
