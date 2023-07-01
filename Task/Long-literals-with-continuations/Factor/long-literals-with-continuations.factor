USING: formatting kernel qw sequences ;

qw{
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
}

"2020-03-23"   ! last revision date in YYYY-MM-DD format

"Last revision: %s\n" printf
[ length ] [ last ] bi
"Number of elements: %d\nLast element: %s\n" printf
