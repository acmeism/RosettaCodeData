use regex::Regex;

const ELEMENT_LIST: &str = r#"
hydrogen helium lithium beryllium boron carbon nitrogen oxygen fluorine
neon sodium magnesium aluminum silicon phosphorous sulfur chlorine argon
potassium calcium scandium titanium vanadium chromium manganese iron cobalt
nickel copper zinc gallium germanium arsenic selenium bromine krypton rubidium
strontium yttrium zirconium niobium molybdenum technetium ruthenium rhodium
palladium silver cadmium indium tin antimony tellurium iodine xenon cesium
barium lanthanum cerium praseodymium neodymium promethium samarium europium
gadolinium terbium dysprosium holmium erbium thulium ytterbium lutetium hafnium
tantalum tungsten rhenium osmium iridium platinum gold mercury thallium lead
bismuth polonium astatine radon francium radium actinium thorium protactinium
uranium neptunium plutonium americium curium berkelium californium einsteinium
fermium mendelevium nobelium lawrencium rutherfordium dubnium seaborgium
bohrium hassium meitnerium darmstadtium roentgenium copernicium nihonium
flerovium moscovium livermorium tennessine oganesson
"#;

fn main() {
    let version = "Tue Sep 3 21:32:48 UTC 2024";
    let elements = Regex::new(r"\s+")
        .unwrap()
        .split(ELEMENT_LIST)
        .filter(|x| !x.is_empty())
        .collect::<Vec<&str>>();
    let element_count = elements.len();
    let last = elements[element_count - 1];

    println!(
        "       Version: {version:>14}\n Element count: {element_count:>3}\n  Last element: {last}"
    );
}
