Rebol [
    title: "Rosetta code: Pick random element"
    file:  %Pick_random_element.r3
    url:   https://rosettacode.org/wiki/Pick_random_element
]

elements: [
    "Hydrogen_H"       "Helium_He"       "Lithium_Li"      "Beryllium_Be"
    "Boron_B"          "Carbon_C"        "Nitrogen_N"      "Oxygen_O"
    "Fluorine_F"       "Neon_Ne"         "Sodium_Na"       "Magnesium_Mg"
    "Aluminium_Al"     "Silicon_Si"      "Phosphorus_P"    "Sulfur_S"
    "Chlorine_Cl"      "Argon_Ar"        "Potassium_K"     "Calcium_Ca"
    "Scandium_Sc"      "Titanium_Ti"     "Vanadium_V"      "Chromium_Cr"
    "Manganese_Mn"     "Iron_Fe"         "Cobalt_Co"       "Nickel_Ni"
    "Copper_Cu"        "Zinc_Zn"         "Gallium_Ga"      "Germanium_Ge"
    "Arsenic_As"       "Selenium_Se"     "Bromine_Br"      "Krypton_Kr"
    "Rubidium_Rb"      "Strontium_Sr"    "Yttrium_Y"       "Zirconium_Zr"
    "Niobium_Nb"       "Molybdenum_Mo"   "Technetium_Tc"   "Ruthenium_Ru"
    "Rhodium_Rh"       "Palladium_Pd"    "Silver_Ag"       "Cadmium_Cd"
    "Indium_In"        "Tin_Sn"          "Antimony_Sb"     "Tellurium_Te"
    "Iodine_I"         "Xenon_Xe"        "Caesium_Cs"      "Barium_Ba"
    "Lanthanum_La"     "Cerium_Ce"       "Praseodymium_Pr" "Neodymium_Nd"
    "Promethium_Pm"    "Samarium_Sm"     "Europium_Eu"     "Gadolinium_Gd"
    "Terbium_Tb"       "Dysprosium_Dy"   "Holmium_Ho"      "Erbium_Er"
    "Thulium_Tm"       "Ytterbium_Yb"    "Lutetium_Lu"     "Hafnium_Hf"
    "Tantalum_Ta"      "Tungsten_W"      "Rhenium_Re"      "Osmium_Os"
    "Iridium_Ir"       "Platinum_Pt"     "Gold_Au"         "Mercury_Hg"
    "Thallium_Tl"      "Lead_Pb"         "Bismuth_Bi"      "Polonium_Po"
    "Astatine_At"      "Radon_Rn"        "Francium_Fr"     "Radium_Ra"
    "Actinium_Ac"      "Thorium_Th"      "Protactinium_Pa" "Uranium_U"
    "Neptunium_Np"     "Plutonium_Pu"    "Americium_Am"    "Curium_Cm"
    "Berkelium_Bk"     "Californium_Cf"  "Einsteinium_Es"  "Fermium_Fm"
    "Mendelevium_Md"   "Nobelium_No"     "Lawrencium_Lr"   "Rutherfordium_Rf"
    "Dubnium_Db"       "Seaborgium_Sg"   "Bohrium_Bh"      "Hassium_Hs"
    "Meitnerium_Mt"    "Darmstadtium_Ds" "Roentgenium_Rg"  "Copernicium_Cn"
    "Nihonium_Nh"      "Flerovium_Fl"    "Moscovium_Mc"    "Livermorium_Lv"
    "Tennessine_Ts"    "Oganesson_Og"    "Ununbium_Uub"    "Ununtrium_Uut"
    "Ununquadium_Uuq"
]

either all [
   block? args: system/script/args
   not empty? args
][
    label: "Specified"
    try/with [
        entry: pick elements args: to integer! first args
    ][
        print ["Invalid script argument:" as-red args]
        print ["Script expects number from 1 to" length? elements]
        quit
    ]
    unless entry [
        print ["Element" as-red args "hasn't been discovered yet"]
        quit
    ]
][
    label: "Random"
    entry: random/only elements
]

set [name symbol] split entry #"_"
print [label "element:" as-green name "-" as-yellow symbol]
