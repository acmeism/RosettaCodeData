do{{)n
   H:   1.008,       He:   4.002602,   Li:   6.94,        Be:   9.0121831,
   B:  10.81,         C:  12.011,       N:  14.007,        O:  15.999,
   F:  18.998403163, Ne:  20.1797,     Na:  22.98976928,  Mg:  24.305,
  Al:  26.9815385,   Si:  28.085,       P:  30.973761998,  S:  32.06,
  Cl:  35.45,         K:  39.0983,     Ar:  39.948,       Ca:  40.078,
  Sc:  44.955908,    Ti:  47.867,       V:  50.9415,      Cr:  51.9961,
  Mn:  54.938044,    Fe:  55.845,      Ni:  58.6934,      Co:  58.933194,
  Cu:  63.546,       Zn:  65.38,       Ga:  69.723,       Ge:  72.63,
  As:  74.921595,    Se:  78.971,      Br:  79.904,       Kr:  83.798,
  Rb:  85.4678,      Sr:  87.62,        Y:  88.90584,     Zr:  91.224,
  Nb:  92.90637,     Mo:  95.95,       Ru: 101.07,        Rh: 102.9055,
  Pd: 106.42,        Ag: 107.8682,     Cd: 112.414,       In: 114.818,
  Sn: 118.71,        Sb: 121.76,        I: 126.90447,     Te: 127.6,
  Xe: 131.293,       Cs: 132.90545196, Ba: 137.327,       La: 138.90547,
  Ce: 140.116,       Pr: 140.90766,    Nd: 144.242,       Pm: 145,
  Sm: 150.36,        Eu: 151.964,      Gd: 157.25,        Tb: 158.92535,
  Dy: 162.5,         Ho: 164.93033,    Er: 167.259,       Tm: 168.93422,
  Yb: 173.054,       Lu: 174.9668,     Hf: 178.49,        Ta: 180.94788,
   W: 183.84,        Re: 186.207,      Os: 190.23,        Ir: 192.217,
  Pt: 195.084,       Au: 196.966569,   Hg: 200.592,       Tl: 204.38,
  Pb: 207.2,         Bi: 208.9804,     Po: 209,           At: 210,
  Rn: 222,           Fr: 223,          Ra: 226,           Ac: 227,
  Pa: 231.03588,     Th: 232.0377,     Np: 237,            U: 238.02891,
  Am: 243,           Pu: 244,          Cm: 247,           Bk: 247,
  Cf: 251,           Es: 252,          Fm: 257,          Ubn: 299,
 Uue: 315
}} rplc ':';'=:';  ',';'[';  LF;''

NB. 0: punctuation, 1: numeric, 2: upper case, 3: lower case
ctyp=: e.&'0123456789' + (2*]~:tolower) + 3*]~:toupper
tokenize=: (0;(0 10#:10*do;._2{{)n
 1.1  2.1  3.1  4.1   NB. start here
 1.2  2.2  3.2  4.2   NB. punctuation is 1 character per word
 1.2  2    3.2  4.2   NB. numeric characters are word forming
 1.2  2.2  3.2  4     NB. upper case always begins a word
 1.2  2.2  3.2  4     NB. lower case always continues a word
}});ctyp a.)&;:

molar_mass=: {{
 W=.,0  NB. weight stack
 M=.,1  NB. multiplier stack
 digit=. (1=ctyp a.)#<"0 a.
 alpha=. (2=ctyp a.)#<"0 a.
 for_t.|.tokenize y do. select. {.;t
   case. '(' do.    W=. (M #.&(2&{.) W), 2}.W
    M=. 1,2}.M
   case. ')' do.    W=. 0,W
    M=. 1,M
   case. digit do.
    M=. (do;t),}.M
   case. alpha do.  W=. (({.W)+({.M)*do;t),}.W
    M=. 1,}.M
   case. do. NB. ignore irrelevant whitespace
  end. end. assert. 1=#W
 <.@+&0.5&.(*&1000){.W
}}

assert   1.008 = molar_mass('H')                  NB. hydrogen
assert   2.016 = molar_mass('H2')                 NB. hydrogen gas
assert  18.015 = molar_mass('H2O')                NB. water
assert  34.014 = molar_mass('H2O2')               NB. hydrogen peroxide
assert  34.014 = molar_mass('(HO)2')              NB. hydrogen peroxide
assert 142.036 = molar_mass('Na2SO4')             NB. sodium sulfate
assert  84.162 = molar_mass('C6H12')              NB. cyclohexane
assert 186.295 = molar_mass('COOH(C(CH3)2)3CH3')  NB. butyric or butanoic acid
assert 176.124 = molar_mass('C6H4O2(OH)4')        NB. vitamin C
assert 386.664 = molar_mass('C27H46O')            NB. cholesterol
assert 315     = molar_mass('Uue')                NB. ununennium
