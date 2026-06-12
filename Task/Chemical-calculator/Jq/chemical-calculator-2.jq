# A "debug" statement has been retained so that the parsed chemical formula can be seen.
def molar_mass(formula):
  {remainder: formula} | Formula |  .result | debug | eval;

def assert(a; b):
  if (a - b)|length > 1e-3 then "\(a) != \(b)" else empty end;

def task:
  assert(   1.008; molar_mass("H")),                  # hydrogen
  assert(   2.016; molar_mass("H2")),                 # hydrogen gas
  assert(  18.015; molar_mass("H2O")),                # water
  assert(  34.014; molar_mass("H2O2")),               # hydrogen peroxide
  assert(  34.014; molar_mass("(HO)2")),              # hydrogen peroxide
  assert( 142.036; molar_mass("Na2SO4")),             # sodium sulfate
  assert(  84.162; molar_mass("C6H12")),              # cyclohexane
  assert( 186.295; molar_mass("COOH(C(CH3)2)3CH3")),  # butyric or butanoic acid
  assert( 176.124; molar_mass("C6H4O2(OH)4")),        # vitamin C
  assert( 386.664; molar_mass("C27H46O")),            # cholesterol
  assert( 315    ; molar_mass("Uue"))                 # ununennium
;
