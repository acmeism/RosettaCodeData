"""Long string literal. Requires Python 3.6+ for f-strings."""

revision = "October 13th 2020"

# String literal continuation. Notice the trailing space at the end of each
# line but the last, and the lack of commas. There is exactly one "blank"
# between each item in the list.
elements = (
    "hydrogen helium lithium beryllium boron carbon nitrogen oxygen fluorine "
    "neon sodium magnesium aluminum silicon phosphorous sulfur chlorine argon "
    "potassium calcium scandium titanium vanadium chromium manganese iron "
    "cobalt nickel copper zinc gallium germanium arsenic selenium bromine "
    "krypton rubidium strontium yttrium zirconium niobium molybdenum "
    "technetium ruthenium rhodium palladium silver cadmium indium tin "
    "antimony tellurium iodine xenon cesium barium lanthanum cerium "
    "praseodymium neodymium promethium samarium europium gadolinium terbium "
    "dysprosium holmium erbium thulium ytterbium lutetium hafnium tantalum "
    "tungsten rhenium osmium iridium platinum gold mercury thallium lead "
    "bismuth polonium astatine radon francium radium actinium thorium "
    "protactinium uranium neptunium plutonium americium curium berkelium "
    "californium einsteinium fermium mendelevium nobelium lawrencium "
    "rutherfordium dubnium seaborgium bohrium hassium meitnerium darmstadtium "
    "roentgenium copernicium nihonium flerovium moscovium livermorium "
    "tennessine oganesson"
)


def report():
    """Write a summary report to stdout."""
    items = elements.split()

    print(f"Last revision date: {revision}")
    print(f"Number of elements: {len(items)}")
    print(f"Last element      : {items[-1]}")


if __name__ == "__main__":
    report()
