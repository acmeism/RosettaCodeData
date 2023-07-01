revised = "February 2, 2021"
-- the long literal string is delimited by double square brackets: [[...]]
-- each word must be separated by at least one whitespace character
-- additional whitespace may optionally be used to improve readability
-- (starting column does not matter, clause length is more than adequate)
longliteral = [[
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
]]
-- the task requires the "final list" as single-space-between string version
-- (a more idiomatic overall approach would be to directly split into a table)
finallist = longliteral:gsub("%s+"," ")

elements = {}
-- longliteral could be used here DIRECTLY instead of using finallist:
for name in finallist:gmatch("%w+") do elements[#elements+1]=name end
print("revised date:  " .. revised)
print("# elements  :  " .. #elements)
print("last element:  " .. elements[#elements])

-- then, if still required, produce a single-space-between string version:
--finallist = table.concat(elements," ")
