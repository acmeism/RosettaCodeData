const MASSES = {
  C:   12.011,
  H:   1.008,
  Na:  22.98976928,
  O:   15.99,
  Sb:  121.76,
  Sn:  118.71,
  S:   32.06,
  Uue: 315
}; // to be continued

function getMolarMass(formula) {
  formula = formula.replace(/[0-9]+/g, x => '*' + x + ' ');
  formula = formula.replace(/[A-Z][A-Z]/g, x => x[0] + '+' + x[1]);
  formula = formula.replace(/[0-9] [A-Z]/g, x => x[0] + '+' + x[2]);
  formula = formula.replace(/[A-Z]\(/g, x => x[0] + '+' + x[1]);
  formula = formula.replace(/[0-9] \(/g, x => x[0] + '+' + x[2]);
  formula = formula.replace(/[A-Z][A-Z]/g, x => x[0] + '+' + x[1]);
  for (let key in MASSES)
    formula = formula.replace(new RegExp(key, 'g'), MASSES[key]);
  return eval(formula);
}

// testing
function getSubNums(str) { return str.replace(/[0-9]/g, x => '₀₁₂₃₄₅₆₇₈₉'[x]); }

let formulae =
  'H H2 H2O H2O2 (HO)2 Na2SO4 C6H12 COOH(C(CH3)2)3CH3 C6H4O2(OH)4 C27H46O Uue'.split(' ');

for (let i = 0; i < formulae.length; i++)
  console.log(`${getSubNums(formulae[i])}: ${getMolarMass(formulae[i]).toPrecision(3)}`);
