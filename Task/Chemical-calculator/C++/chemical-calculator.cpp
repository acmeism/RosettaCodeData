#include <iomanip>
#include <iostream>
#include <map>
#include <string>
#include <vector>

std::map<std::string, double> atomicMass = {
    {"H", 1.008},
    {"He",    4.002602},
    {"Li",    6.94},
    {"Be",    9.0121831},
    {"B",    10.81},
    {"C",    12.011},
    {"N",    14.007},
    {"O",    15.999},
    {"F",    18.998403163},
    {"Ne",   20.1797},
    {"Na",   22.98976928},
    {"Mg",   24.305},
    {"Al",   26.9815385},
    {"Si",   28.085},
    {"P",    30.973761998},
    {"S",    32.06},
    {"Cl",   35.45},
    {"Ar",   39.948},
    {"K",    39.0983},
    {"Ca",   40.078},
    {"Sc",   44.955908},
    {"Ti",   47.867},
    {"V",    50.9415},
    {"Cr",   51.9961},
    {"Mn",   54.938044},
    {"Fe",   55.845},
    {"Co",   58.933194},
    {"Ni",   58.6934},
    {"Cu",   63.546},
    {"Zn",   65.38},
    {"Ga",   69.723},
    {"Ge",   72.630},
    {"As",   74.921595},
    {"Se",   78.971},
    {"Br",   79.904},
    {"Kr",   83.798},
    {"Rb",   85.4678},
    {"Sr",   87.62},
    {"Y",    88.90584},
    {"Zr",   91.224},
    {"Nb",   92.90637},
    {"Mo",   95.95},
    {"Ru",  101.07},
    {"Rh",  102.90550},
    {"Pd",  106.42},
    {"Ag",  107.8682},
    {"Cd",  112.414},
    {"In",  114.818},
    {"Sn",  118.710},
    {"Sb",  121.760},
    {"Te",  127.60},
    {"I",   126.90447},
    {"Xe",  131.293},
    {"Cs",  132.90545196},
    {"Ba",  137.327},
    {"La",  138.90547},
    {"Ce",  140.116},
    {"Pr",  140.90766},
    {"Nd",  144.242},
    {"Pm",  145},
    {"Sm",  150.36},
    {"Eu",  151.964},
    {"Gd",  157.25},
    {"Tb",  158.92535},
    {"Dy",  162.500},
    {"Ho",  164.93033},
    {"Er",  167.259},
    {"Tm",  168.93422},
    {"Yb",  173.054},
    {"Lu",  174.9668},
    {"Hf",  178.49},
    {"Ta",  180.94788},
    {"W",   183.84},
    {"Re",  186.207},
    {"Os",  190.23},
    {"Ir",  192.217},
    {"Pt",  195.084},
    {"Au",  196.966569},
    {"Hg",  200.592},
    {"Tl",  204.38},
    {"Pb",  207.2},
    {"Bi",  208.98040},
    {"Po",  209},
    {"At",  210},
    {"Rn",  222},
    {"Fr",  223},
    {"Ra",  226},
    {"Ac",  227},
    {"Th",  232.0377},
    {"Pa",  231.03588},
    {"U",   238.02891},
    {"Np",  237},
    {"Pu",  244},
    {"Am",  243},
    {"Cm",  247},
    {"Bk",  247},
    {"Cf",  251},
    {"Es",  252},
    {"Fm",  257},
    {"Uue", 315},
    {"Ubn", 299},
};

double evaluate(std::string s) {
    s += '[';

    double sum = 0.0;
    std::string symbol;
    std::string number;

    for (auto c : s) {
        if ('@' <= c && c <= '[') {
            // @, A-Z
            int n = 1;
            if (number != "") {
                n = stoi(number);
            }
            if (symbol != "") {
                sum += atomicMass[symbol] * n;
            }
            if (c == '[') {
                break;
            }
            symbol = c;
            number = "";
        } else if ('a' <= c && c <= 'z') {
            symbol += c;
        } else if ('0' <= c && c <= '9') {
            number += c;
        } else {
            std::string msg = "Unexpected symbol ";
            msg += c;
            msg += " in molecule";
            throw std::runtime_error(msg);
        }
    }

    return sum;
}

std::string replaceFirst(const std::string &text, const std::string &search, const std::string &replace) {
    auto pos = text.find(search);
    if (pos == std::string::npos) {
        return text;
    }

    auto beg = text.substr(0, pos);
    auto end = text.substr(pos + search.length());
    return beg + replace + end;
}

std::string replaceParens(std::string s) {
    char letter = 'a';
    while (true) {
        auto start = s.find("(");
        if (start == std::string::npos) {
            break;
        }

        for (size_t i = start + 1; i < s.length(); i++) {
            if (s[i] == ')') {
                auto expr = s.substr(start + 1, i - start - 1);
                std::string symbol = "@";
                symbol += letter;
                auto search = s.substr(start, i + 1 - start);
                s = replaceFirst(s, search, symbol);
                atomicMass[symbol] = evaluate(expr);
                letter++;
                break;
            }
            if (s[i] == '(') {
                start = i;
                continue;
            }
        }
    }
    return s;
}

int main() {
    std::vector<std::string> molecules = {
        "H", "H2", "H2O", "H2O2", "(HO)2", "Na2SO4", "C6H12",
        "COOH(C(CH3)2)3CH3", "C6H4O2(OH)4", "C27H46O", "Uue"
    };
    for (auto molecule : molecules) {
        auto mass = evaluate(replaceParens(molecule));
        std::cout << std::setw(17) << molecule << " -> " << std::setw(7) << std::fixed << std::setprecision(3) << mass << '\n';
    }

    return 0;
}
