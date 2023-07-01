using Dates

# FOR FUTURE EDITORS:
#
# Add to this list by adding more lines of text to this listing, placing the
# new words of text before the last """ below, with all entries separated by
# spaces.
#
const CHEMICAL_ELEMENTS = """

hydrogen helium lithium beryllium boron carbon nitrogen oxygen fluorine neon
sodium magnesium aluminum silicon phosphorus sulfur chlorine argon potassium
calcium scandium titanium vanadium chromium manganese iron cobalt nickel copper
zinc gallium germanium arsenic selenium bromine krypton rubidium strontium
yttrium zirconium niobium molybdenum technetium ruthenium rhodium palladium
silver cadmium indium tin antimony tellurium iodine xenon cesium barium
lanthanum cerium praseodymium neodymium promethium samarium europium gadolinium
terbium dysprosium holmium erbium thulium ytterbium lutetium hafnium tantalum
tungsten rhenium osmium iridium platinum gold mercury thallium lead bismuth
polonium astatine radon francium radium actinium thorium protactinium uranium
neptunium plutonium americium curium berkelium californium einsteinium fermium
mendelevium nobelium lawrencium rutherfordium dubnium seaborgium bohrium hassium
meitnerium darmstadtium roentgenium copernicium nihonium flerovium moscovium
livermorium tennessine oganesson

"""
#
# END OF ABOVE LISTING--DO NOT ADD ELEMENTS BELOW THIS LINE
#

const EXCLUDED = split(strip(
"ununennium unquadnilium triunhexium penthextrium penthexpentium " *
" septhexunium octenntrium ennennbium"), r"\s+")

function process_chemical_element_list(s = CHEMICAL_ELEMENTS)
    # remove leading and trailing whitespace
    s = strip(s)
    # return a list after splitting using whitespace between words as a separator
    return [element for element in split(s, r"\s+") if !(element in EXCLUDED)]
end

function report()
    filedate = Dates.unix2datetime(mtime(@__FILE__))
    element_list = process_chemical_element_list()
    element_count = length(element_list)
    last_element_in_list = element_list[end]

    println("File last revised (formatted as dateTtime): ", filedate, " GMT")
    println("Length of element list: ", element_count)
    println("last element in list: ", last_element_in_list)
end

report()
