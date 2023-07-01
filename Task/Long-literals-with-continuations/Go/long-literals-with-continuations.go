package main

import (
    "fmt"
    "regexp"
    "strings"
)

// Uses a 'raw string literal' which is a character sequence enclosed in back quotes.
// Within the quotes any character (including new line) may appear except
// back quotes themselves.
var elements = `
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
`

func main() {
    lastRevDate := "March 24th, 2020"
    re := regexp.MustCompile(`\s+`) // split on one or more whitespace characters
    els := re.Split(strings.TrimSpace(elements), -1)
    numEls := len(els)
    // Recombine as a single string with elements separated by a single space.
    elements2 := strings.Join(els, " ")
    // Required output.
    fmt.Println("Last revision Date: ", lastRevDate)
    fmt.Println("Number of elements: ", numEls)
    // The compiler complains that 'elements2' is unused if we don't use
    // something like this to get the last element rather than just els[numEls-1].
    lix := strings.LastIndex(elements2, " ") // get index of last space
    fmt.Println("Last element      : ", elements2[lix+1:])
}
