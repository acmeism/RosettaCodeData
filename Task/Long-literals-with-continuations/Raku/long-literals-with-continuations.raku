my %periodic;
%periodic<revision-date> = Date.new(2020,3,23);
%periodic<table> = |<

         Hydrogen  1.0079     H             Helium  4.0026    He
          Lithium  6.941     Li          Beryllium  9.0122    Be
            Boron  10.811     B             Carbon  12.0107    C
         Nitrogen  14.0067    N             Oxygen  15.9994    O
         Fluorine  18.9984    F               Neon  20.1797   Ne
           Sodium  22.9897   Na          Magnesium  24.305    Mg
         Aluminum  26.9815   Al            Silicon  28.0855   Si
       Phosphorus  30.9738    P             Sulfur  32.065     S
         Chlorine  35.453    Cl          Potassium  39.0983    K
            Argon  39.948    Ar            Calcium  40.078    Ca
         Scandium  44.9559   Sc           Titanium  47.867    Ti
         Vanadium  50.9415    V           Chromium  51.9961   Cr
        Manganese  54.938    Mn               Iron  55.845    Fe
           Nickel  58.6934   Ni             Cobalt  58.9332   Co
           Copper  63.546    Cu               Zinc  65.39     Zn
          Gallium  69.723    Ga          Germanium  72.64     Ge
          Arsenic  74.9216   As           Selenium  78.96     Se
          Bromine  79.904    Br            Krypton  83.8      Kr
         Rubidium  85.4678   Rb          Strontium  87.62     Sr
          Yttrium  88.9059    Y          Zirconium  91.224    Zr
          Niobium  92.9064   Nb         Molybdenum  95.94     Mo
       Technetium  98        Tc          Ruthenium  101.07    Ru
          Rhodium  102.9055  Rh          Palladium  106.42    Pd
           Silver  107.8682  Ag            Cadmium  112.411   Cd
           Indium  114.818   In                Tin  118.71    Sn
         Antimony  121.76    Sb             Iodine  126.9045   I
        Tellurium  127.6     Te              Xenon  131.293   Xe
           Cesium  132.9055  Cs             Barium  137.327   Ba
        Lanthanum  138.9055  La             Cerium  140.116   Ce
     Praseodymium  140.9077  Pr          Neodymium  144.24    Nd
       Promethium  145       Pm           Samarium  150.36    Sm
         Europium  151.964   Eu         Gadolinium  157.25    Gd
          Terbium  158.9253  Tb         Dysprosium  162.5     Dy
          Holmium  164.9303  Ho             Erbium  167.259   Er
          Thulium  168.9342  Tm          Ytterbium  173.04    Yb
         Lutetium  174.967   Lu            Hafnium  178.49    Hf
         Tantalum  180.9479  Ta           Tungsten  183.84     W
          Rhenium  186.207   Re             Osmium  190.23    Os
          Iridium  192.217   Ir           Platinum  195.078   Pt
             Gold  196.9665  Au            Mercury  200.59    Hg
         Thallium  204.3833  Tl               Lead  207.2     Pb
          Bismuth  208.9804  Bi           Polonium  209       Po
         Astatine  210       At              Radon  222       Rn
         Francium  223       Fr             Radium  226       Ra
         Actinium  227       Ac       Protactinium  231.0359  Pa
          Thorium  232.0381  Th          Neptunium  237       Np
          Uranium  238.0289   U          Americium  243       Am
        Plutonium  244       Pu             Curium  247       Cm
        Berkelium  247       Bk        Californium  251       Cf
      Einsteinium  252       Es            Fermium  257       Fm
      Mendelevium  258       Md           Nobelium  259       No
    Rutherfordium  261       Rf         Lawrencium  262       Lr
          Dubnium  262       Db            Bohrium  264       Bh
       Seaborgium  266       Sg         Meitnerium  268       Mt
      Roentgenium  272       Rg            Hassium  277       Hs
     Darmstadtium  ???       Ds        Copernicium  ???       Cn
         Nihonium  ???       Nh          Flerovium  ???       Fl
        Moscovium  ???       Mc        Livermorium  ???       Lv
       Tennessine  ???       Ts          Oganesson  ???       Og

>.words.map: { (:name($^a), :weight($^b), :symbol($^c)).hash };

put 'Revision date: ',                                   %periodic<revision-date>;
put 'Last element by position (nominally by weight): ',  %periodic<table>.tail.<name>;
put 'Total number of elements: ',                        %periodic<table>.elems;
put 'Last element sorted by full name: ',                %periodic<table>.sort( *.<name> ).tail.<name>;
put 'Longest element name: ',                            %periodic<table>.sort( *.<name>.chars ).tail.<name>;
put 'Shortest element name: ',                           %periodic<table>.sort( -*.<name>.chars ).tail.<name>;
put 'Symbols for elements whose name starts with "P": ', %periodic<table>.grep( *.<name>.starts-with('P') )».<symbol>;
put "Elements with molecular weight between 20 & 40:\n ",%periodic<table>.grep( {+.<weight> ~~ Numeric and 20 < .<weight> < 40} )».<name>;
put "SCRN: ",                                            %periodic<table>[87,17,92]».<symbol>.join.tclc;
