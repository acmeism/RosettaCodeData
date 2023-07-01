require "time"

last_revision = Time.utc year: 2021, month: 2, day: 25

# the `%w()` literal creates an array from a whitespace-delimited string literal
# it's equivalent to %(string literal).split
# https://crystal-lang.org/reference/syntax_and_semantics/literals/string.html
element_list : Array(String) = %w(
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
tennessine   oganesson)

puts last_revision.to_s "last revised %B %e, %Y"
puts "number of elements: #{element_list.size}"
puts "highest element: #{element_list.last}"
