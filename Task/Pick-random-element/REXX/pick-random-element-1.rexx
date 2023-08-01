/*REXX program picks a   random element   from a list   (tongue in cheek, a visual pun).*/
l=  "Hydrogen_H Helium_He Lithium_Li Beryllium_Be Boron_B"
l=l "Carbon_C Nitrogen_N Oxygen_O Fluorine_F Neon_Ne Sodium_Na"
l=l "Magnesium_Mg Aluminium_Al Silicon_Si Phosphorus_P Sulfur_S"
l=l "Chlorine_Cl Argon_Ar Potassium_K Calcium_Ca Scandium_Sc"
l=l "Titanium_Ti Vanadium_V Chromium_Cr Manganese_Mn Iron_Fe"
l=l "Cobalt_Co Nickel_Ni Copper_Cu Zinc_Zn Gallium_Ga"
l=l "Germanium_Ge Arsenic_As Selenium_Se Bromine_Br Krypton_Kr"
l=l "Rubidium_Rb Strontium_Sr Yttrium_Y Zirconium_Zr Niobium_Nb"
l=l "Molybdenum_Mo Technetium_Tc Ruthenium_Ru Rhodium_Rh"
l=l "Palladium_Pd Silver_Ag Cadmium_Cd Indium_In Tin_Sn"
l=l "Antimony_Sb Tellurium_Te Iodine_I Xenon_Xe Caesium_Cs"
l=l "Barium_Ba Lanthanum_La Cerium_Ce Praseodymium_Pr"
l=l "Neodymium_Nd Promethium_Pm Samarium_Sm Europium_Eu"
l=l "Gadolinium_Gd Terbium_Tb Dysprosium_Dy Holmium_Ho Erbium_Er"
l=l "Thulium_Tm Ytterbium_Yb Lutetium_Lu Hafnium_Hf Tantalum_Ta"
l=l "Tungsten_W Rhenium_Re Osmium_Os Iridium_Ir Platinum_Pt"
l=l "Gold_Au Mercury_Hg Thallium_Tl Lead_Pb Bismuth_Bi"
l=l "Polonium_Po Astatine_At Radon_Rn Francium_Fr Radium_Ra"
l=l "Actinium_Ac Thorium_Th Protactinium_Pa Uranium_U"
l=l "Neptunium_Np Plutonium_Pu Americium_Am Curium_Cm"
l=l "Berkelium_Bk Californium_Cf Einsteinium_Es Fermium_Fm"
l=l "Mendelevium_Md Nobelium_No Lawrencium_Lr Rutherfordium_Rf"
l=l "Dubnium_Db Seaborgium_Sg Bohrium_Bh Hassium_Hs Meitnerium_Mt"
l=l "Darmstadtium_Ds Roentgenium_Rg Copernicium_Cn Nihonium_Nh"
l=l "Flerovium_Fl Moscovium_Mc Livermorium_Lv Tennessine_Ts"
l=l "Oganesson_Og Ununbium_Uub Ununtrium_Uut Ununquadium_Uuq"
n=words(l)                       /* Number of known elements            */
                                 /*-----  You can't trust atoms,   -----*/
                                 /*-----  they make everything up. -----*/
Parse Arg pick                   /* atomic number specified             */
If pick>n Then Do
  Say 'Element' pick 'hasn''t been discovered by now'
  Exit
  End
take=pick
If pick='' Then
  take=random(1,n)

item=word(l,take)                /*pick the specified or random element */
Parse Var item name '_' symbol
If pick='' Then
  which='Random'
Else
  which='Specified'
Say which 'element: ' take name '('symbol')' /*stick a fork in it,  we're all done. */
