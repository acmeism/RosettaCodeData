import Foundation

struct Chem {
  struct Molecule {
    var formula: String
    var parts: [Molecule]
    var quantity = 1

    var molarMass: Double {
      switch parts.count {
      case 0:
        return Chem.atomicWeights[formula]! * Double(quantity)
      case _:
        return parts.lazy.map({ $0.molarMass }).reduce(0, +) * Double(quantity)
      }
    }

    private init(formula: String, parts: [Molecule], quantity: Int) {
      self.formula = formula
      self.parts = parts
      self.quantity = quantity
    }

    init?(fromString str: String) {
      guard let mol = Molecule.parseString(str[...]) else {
        return nil
      }

      self = mol
    }

    private static func parseString(_ str: Substring) -> Molecule? {
      guard !str.isEmpty else {
        return nil
      }

      var parts = [Molecule]()
      var workingMol = ""
      var idx = str.startIndex

      func completeAtom() -> Bool {
        guard Chem.atomicWeights.keys.contains(workingMol) else {
          return false
        }

        parts.append(Molecule(formula: workingMol, parts: [], quantity: 1))
        workingMol = ""

        return true
      }

      while idx != str.endIndex {
        let char = str[idx]

        guard char.isASCII else {
          return nil
        }

        if (char.isUppercase || char == "(" || char.isNumber) && !workingMol.isEmpty {
          guard completeAtom() else {
            return nil
          }
        }

        if char == "(" {
          var parenLevel = 1

          let subMolStart = str.index(after: idx)
          idx = subMolStart

          while parenLevel != 0 {
            guard idx != str.endIndex else {
              return nil
            }

            if str[idx] == "(" {
              parenLevel += 1
            } else if str[idx] == ")" {
              parenLevel -= 1
            }

            if parenLevel != 0 {
              idx = str.index(after: idx)
            }
          }

          guard let subMol = parseString(str[subMolStart..<idx]) else {
            return nil
          }

          parts.append(subMol)

          idx = str.index(after: idx)

          continue
        } else if char == ")" {
          fatalError()
        }

        workingMol.append(char)

        if char.isNumber {
          guard !parts.isEmpty else {
            return nil
          }

          var workNum = workingMol

          idx = str.index(after: idx)

          while idx != str.endIndex && str[idx].isNumber {
            workNum.append(str[idx])
            idx = str.index(after: idx)
          }

          parts[parts.count - 1].quantity = Int(workNum)!
          workingMol = ""

          continue
        }

        idx = str.index(after: idx)
      }

      guard workingMol.isEmpty || completeAtom() else {
        return nil
      }

      return Molecule(formula: String(str), parts: parts, quantity: 1)
    }
  }

  static func calculateMolarMass(of chem: String) -> Double? {
    guard let mol = Molecule(fromString: chem) else {
      return nil
    }

    return mol.molarMass
  }

  fileprivate static let atomicWeights = [
    "H":  1.008,
    "He": 4.002602,
    "Li": 6.94,
    "Be": 9.0121831,
    "B": 10.81,
    "C": 12.011,
    "N": 14.007,
    "O": 15.999,
    "F": 18.998403163,
    "Ne": 20.1797,
    "Na": 22.98976928,
    "Mg": 24.305,
    "Al": 26.9815385,
    "Si": 28.085,
    "P": 30.973761998,
    "S": 32.06,
    "Cl": 35.45,
    "K": 39.0983,
    "Ar": 39.948,
    "Ca": 40.078,
    "Sc": 44.955908,
    "Ti": 47.867,
    "V": 50.9415,
    "Cr": 51.9961,
    "Mn": 54.938044,
    "Fe": 55.845,
    "Ni": 58.6934,
    "Co": 58.933194,
    "Cu": 63.546,
    "Zn": 65.38,
    "Ga": 69.723,
    "Ge": 72.63,
    "As": 74.921595,
    "Se": 78.971,
    "Br": 79.904,
    "Kr": 83.798,
    "Rb": 85.4678,
    "Sr": 87.62,
    "Y": 88.90584,
    "Zr": 91.224,
    "Nb": 92.90637,
    "Mo": 95.95,
    "Ru": 101.07,
    "Rh": 102.9055,
    "Pd": 106.42,
    "Ag": 107.8682,
    "Cd": 112.414,
    "In": 114.818,
    "Sn": 118.71,
    "Sb": 121.76,
    "I": 126.90447,
    "Te": 127.6,
    "Xe": 131.293,
    "Cs": 132.90545196,
    "Ba": 137.327,
    "La": 138.90547,
    "Ce": 140.116,
    "Pr": 140.90766,
    "Nd": 144.242,
    "Pm": 145,
    "Sm": 150.36,
    "Eu": 151.964,
    "Gd": 157.25,
    "Tb": 158.92535,
    "Dy": 162.5,
    "Ho": 164.93033,
    "Er": 167.259,
    "Tm": 168.93422,
    "Yb": 173.054,
    "Lu": 174.9668,
    "Hf": 178.49,
    "Ta": 180.94788,
    "W": 183.84,
    "Re": 186.207,
    "Os": 190.23,
    "Ir": 192.217,
    "Pt": 195.084,
    "Au": 196.966569,
    "Hg": 200.592,
    "Tl": 204.38,
    "Pb": 207.2,
    "Bi": 208.9804,
    "Po": 209,
    "At": 210,
    "Rn": 222,
    "Fr": 223,
    "Ra": 226,
    "Ac": 227,
    "Pa": 231.03588,
    "Th": 232.0377,
    "Np": 237,
    "U": 238.02891,
    "Am": 243,
    "Pu": 244,
    "Cm": 247,
    "Bk": 247,
    "Cf": 251,
    "Es": 252,
    "Fm": 257,
    "Ubn": 299,
    "Uue": 315
  ]
}

let testCases = [
  ("H", "1.008"),
  ("H2", "2.016"),
  ("H2O", "18.015"),
  ("H2O2", "34.014"),
  ("(HO)2", "34.014"),
  ("Na2SO4", "142.036"),
  ("C6H12", "84.162"),
  ("COOH(C(CH3)2)3CH3", "186.295"),
  ("C6H4O2(OH)4", "176.124"),
  ("C27H46O", "386.664"),
  ("Uue", "315.000")
]

let fmt = { String(format: "%.3f", $0) }

for (mol, expected) in testCases {
  guard let mass = Chem.calculateMolarMass(of: mol) else {
    fatalError("Bad formula \(mol)")
  }

  assert(fmt(mass) == expected, "Incorrect result")

  print("\(mol) => \(fmt(mass))")
}
