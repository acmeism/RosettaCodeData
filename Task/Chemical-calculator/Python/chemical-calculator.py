import re

ATOMIC_MASS = {"H":1.008, "C":12.011, "O":15.999, "Na":22.98976928, "S":32.06, "Uue":315}

mul = lambda x : '*' + x.group(0)
def add(x) :
    name = x.group(0)
    return '+' + name if name == '(' else '+' + str(ATOMIC_MASS[name])

def molar_mass(s):
    nazwa = s
    s = re.sub(r"\d+", mul, s)
    s = re.sub(r"[A-Z][a-z]{0,2}|\(", add, s)
    return print("Atomic mass {:17s} {} {:7.3f}".format(nazwa,'\t',round(eval(s),3)))

if __name__ == "__main__":
    formulae = "H H2 H2O Na2SO4 C6H12 COOH(C(CH3)2)3CH3"
    for formula in formulae.split(" "):
        molar_mass(formula)
