# FOR FUTURE EDITORS:
# To add chemical elements, modify the CHEMICAL_ELEMENTS function,
# ensuring that the date is updated properly and that there is at least one
# space between the element names after concatenation of the strings.
# Do not include any of the "unnamed" chemical element names such as ununennium.

def CHEMICAL_ELEMENTS:
  {date: "Wed Jun 23 00:00:00 EDT 2021",
   elements: (

  "hydrogen helium lithium beryllium boron carbon nitrogen oxygen fluorine neon "
  + "sodium magnesium aluminum silicon phosphorus sulfur chlorine argon potassium "
  + "calcium scandium titanium vanadium chromium manganese iron cobalt nickel copper "
  + "zinc gallium germanium arsenic selenium bromine krypton rubidium strontium "
  + "yttrium zirconium niobium molybdenum technetium ruthenium rhodium palladium "
  + "silver cadmium indium tin antimony tellurium iodine xenon cesium barium "
  + "lanthanum cerium praseodymium neodymium promethium samarium europium gadolinium "
  + "terbium dysprosium holmium erbium thulium ytterbium lutetium hafnium tantalum "
  + "tungsten rhenium osmium iridium platinum gold mercury thallium lead bismuth "
  + "polonium astatine radon francium radium actinium thorium protactinium uranium "
  + "neptunium plutonium americium curium berkelium californium einsteinium fermium "
  + "mendelevium nobelium lawrencium rutherfordium dubnium seaborgium bohrium hassium "
  + "meitnerium darmstadtium roentgenium copernicium nihonium flerovium moscovium "
  + "livermorium tennessine oganesson"

  ) }
;

def chemical_elements_array:
  CHEMICAL_ELEMENTS.elements
  # remove leading and trailing whitespace
  | sub("^ *";"") | sub(" *$";"")
  # return a list after splitting using whitespace between words as a separator
  | [splits("[ \t]+")] ;

def report:
  chemical_elements_array as $a
  | "List last revised:      \(CHEMICAL_ELEMENTS.date)",
    "Length of element list: \($a|length)",
    "Last element in list:   \($a[-1])";

report
