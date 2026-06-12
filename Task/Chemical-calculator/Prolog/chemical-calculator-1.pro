:- use_module(library(dcg/basics)).
:- use_module(library(dcg/high_order)).

:- initialization(main, main).
main([Input]) :-
    atom_codes(Input, Codes),
    phrase(chemical(Mass), Codes),
    writeln(Mass).

chemical(Mass) --> chemical(0, Mass), !.

chemical(M0, M) -->
    ( "(", chemical(0, M1), ")" | element_mass(M1) ),
    optional(integer(C), { C = 1 }),
    { M2 is M0 + M1 * C },
    ( chemical(M2, M) | { M2 = M } ).

element_mass(  1.008)         --> "H".
element_mass(  4.002602)      --> "He".
element_mass(  6.94)          --> "Li".
element_mass(  9.0121831)     --> "Be".
element_mass( 10.81)          --> "B".
element_mass( 12.011)         --> "C".
element_mass( 14.007)         --> "N".
element_mass( 15.999)         --> "O".
element_mass( 18.998403163)   --> "F".
element_mass( 20.1797)        --> "Ne".
element_mass( 22.98976928)    --> "Na".
element_mass( 24.305)         --> "Mg".
element_mass( 26.9815385)     --> "Al".
element_mass( 28.085)         --> "Si".
element_mass( 30.973761998)   --> "P".
element_mass( 32.06)          --> "S".
element_mass( 35.45)          --> "Cl".
element_mass( 39.0983)        --> "K".
element_mass( 39.948)         --> "Ar".
element_mass( 40.078)         --> "Ca".
element_mass( 44.955908)      --> "Sc".
element_mass( 47.867)         --> "Ti".
element_mass( 50.9415)        --> "V".
element_mass( 51.9961)        --> "Cr".
element_mass( 54.938044)      --> "Mn".
element_mass( 55.845)         --> "Fe".
element_mass( 58.6934)        --> "Ni".
element_mass( 58.933194)      --> "Co".
element_mass( 63.546)         --> "Cu".
element_mass( 65.38)          --> "Zn".
element_mass( 69.723)         --> "Ga".
element_mass( 72.63)          --> "Ge".
element_mass( 74.921595)      --> "As".
element_mass( 78.971)         --> "Se".
element_mass( 79.904)         --> "Br".
element_mass( 83.798)         --> "Kr".
element_mass( 85.4678)        --> "Rb".
element_mass( 87.62)          --> "Sr".
element_mass( 88.90584)       --> "Y".
element_mass( 91.224)         --> "Zr".
element_mass( 92.90637)       --> "Nb".
element_mass( 95.95)          --> "Mo".
element_mass(101.07)          --> "Ru".
element_mass(102.9055)        --> "Rh".
element_mass(106.42)          --> "Pd".
element_mass(107.8682)        --> "Ag".
element_mass(112.414)         --> "Cd".
element_mass(114.818)         --> "In".
element_mass(118.71)          --> "Sn".
element_mass(121.76)          --> "Sb".
element_mass(126.90447)       --> "I".
element_mass(127.6)           --> "Te".
element_mass(131.293)         --> "Xe".
element_mass(132.90545196)    --> "Cs".
element_mass(137.327)         --> "Ba".
element_mass(138.90547)       --> "La".
element_mass(140.116)         --> "Ce".
element_mass(140.90766)       --> "Pr".
element_mass(144.242)         --> "Nd".
element_mass(145)             --> "Pm".
element_mass(150.36)          --> "Sm".
element_mass(151.964)         --> "Eu".
element_mass(157.25)          --> "Gd".
element_mass(158.92535)       --> "Tb".
element_mass(162.5)           --> "Dy".
element_mass(164.93033)       --> "Ho".
element_mass(167.259)         --> "Er".
element_mass(168.93422)       --> "Tm".
element_mass(173.054)         --> "Yb".
element_mass(174.9668)        --> "Lu".
element_mass(178.49)          --> "Hf".
element_mass(180.94788)       --> "Ta".
element_mass(183.84)          --> "W".
element_mass(186.207)         --> "Re".
element_mass(190.23)          --> "Os".
element_mass(192.217)         --> "Ir".
element_mass(195.084)         --> "Pt".
element_mass(196.966569)      --> "Au".
element_mass(200.592)         --> "Hg".
element_mass(204.38)          --> "Tl".
element_mass(207.2)           --> "Pb".
element_mass(208.9804)        --> "Bi".
element_mass(209)             --> "Po".
element_mass(210)             --> "At".
element_mass(222)             --> "Rn".
element_mass(223)             --> "Fr".
element_mass(226)             --> "Ra".
element_mass(227)             --> "Ac".
element_mass(231.03588)       --> "Pa".
element_mass(232.0377)        --> "Th".
element_mass(237)             --> "Np".
element_mass(238.02891)       --> "U".
element_mass(243)             --> "Am".
element_mass(244)             --> "Pu".
element_mass(247)             --> "Cm".
element_mass(247)             --> "Bk".
element_mass(251)             --> "Cf".
element_mass(252)             --> "Es".
element_mass(257)             --> "Fm".
element_mass(299)             --> "Ubn".
element_mass(315)             --> "Uue".
