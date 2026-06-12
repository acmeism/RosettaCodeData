#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef char *string;

typedef struct node_t {
    string symbol;
    double weight;
    struct node_t *next;
} node;

node *make_node(string symbol, double weight) {
    node *nptr = malloc(sizeof(node));
    if (nptr) {
        nptr->symbol = symbol;
        nptr->weight = weight;
        nptr->next = NULL;
        return nptr;
    }
    return NULL;
}

void free_node(node *ptr) {
    if (ptr) {
        free_node(ptr->next);
        ptr->next = NULL;
        free(ptr);
    }
}

node *insert(string symbol, double weight, node *head) {
    node *nptr = make_node(symbol, weight);
    nptr->next = head;
    return nptr;
}

node *dic;
void init() {
    dic = make_node("H", 1.008);
    dic = insert("He", 4.002602, dic);
    dic = insert("Li", 6.94, dic);
    dic = insert("Be", 9.0121831, dic);
    dic = insert("B", 10.81, dic);
    dic = insert("C", 12.011, dic);
    dic = insert("N", 14.007, dic);
    dic = insert("O", 15.999, dic);
    dic = insert("F", 18.998403163, dic);
    dic = insert("Ne", 20.1797, dic);
    dic = insert("Na", 22.98976928, dic);
    dic = insert("Mg", 24.305, dic);
    dic = insert("Al", 26.9815385, dic);
    dic = insert("Si", 28.085, dic);
    dic = insert("P", 30.973761998, dic);
    dic = insert("S", 32.06, dic);
    dic = insert("Cl", 35.45, dic);
    dic = insert("Ar", 39.948, dic);
    dic = insert("K", 39.0983, dic);
    dic = insert("Ca", 40.078, dic);
    dic = insert("Sc", 44.955908, dic);
    dic = insert("Ti", 47.867, dic);
    dic = insert("V", 50.9415, dic);
    dic = insert("Cr", 51.9961, dic);
    dic = insert("Mn", 54.938044, dic);
    dic = insert("Fe", 55.845, dic);
    dic = insert("Co", 58.933194, dic);
    dic = insert("Ni", 58.6934, dic);
    dic = insert("Cu", 63.546, dic);
    dic = insert("Zn", 65.38, dic);
    dic = insert("Ga", 69.723, dic);
    dic = insert("Ge", 72.630, dic);
    dic = insert("As", 74.921595, dic);
    dic = insert("Se", 78.971, dic);
    dic = insert("Br", 79.904, dic);
    dic = insert("Kr", 83.798, dic);
    dic = insert("Rb", 85.4678, dic);
    dic = insert("Sr", 87.62, dic);
    dic = insert("Y", 88.90584, dic);
    dic = insert("Zr", 91.224, dic);
    dic = insert("Nb", 92.90637, dic);
    dic = insert("Mo", 95.95, dic);
    dic = insert("Ru", 101.07, dic);
    dic = insert("Rh", 102.90550, dic);
    dic = insert("Pd", 106.42, dic);
    dic = insert("Ag", 107.8682, dic);
    dic = insert("Cd", 112.414, dic);
    dic = insert("In", 114.818, dic);
    dic = insert("Sn", 118.710, dic);
    dic = insert("Sb", 121.760, dic);
    dic = insert("Te", 127.60, dic);
    dic = insert("I", 126.90447, dic);
    dic = insert("Xe", 131.293, dic);
    dic = insert("Cs", 132.90545196, dic);
    dic = insert("Ba", 137.327, dic);
    dic = insert("La", 138.90547, dic);
    dic = insert("Ce", 140.116, dic);
    dic = insert("Pr", 140.90766, dic);
    dic = insert("Nd", 144.242, dic);
    dic = insert("Pm", 145, dic);
    dic = insert("Sm", 150.36, dic);
    dic = insert("Eu", 151.964, dic);
    dic = insert("Gd", 157.25, dic);
    dic = insert("Tb", 158.92535, dic);
    dic = insert("Dy", 162.500, dic);
    dic = insert("Ho", 164.93033, dic);
    dic = insert("Er", 167.259, dic);
    dic = insert("Tm", 168.93422, dic);
    dic = insert("Yb", 173.054, dic);
    dic = insert("Lu", 174.9668, dic);
    dic = insert("Hf", 178.49, dic);
    dic = insert("Ta", 180.94788, dic);
    dic = insert("W", 183.84, dic);
    dic = insert("Re", 186.207, dic);
    dic = insert("Os", 190.23, dic);
    dic = insert("Ir", 192.217, dic);
    dic = insert("Pt", 195.084, dic);
    dic = insert("Au", 196.966569, dic);
    dic = insert("Hg", 200.592, dic);
    dic = insert("Tl", 204.38, dic);
    dic = insert("Pb", 207.2, dic);
    dic = insert("Bi", 208.98040, dic);
    dic = insert("Po", 209, dic);
    dic = insert("At", 210, dic);
    dic = insert("Rn", 222, dic);
    dic = insert("Fr", 223, dic);
    dic = insert("Ra", 226, dic);
    dic = insert("Ac", 227, dic);
    dic = insert("Th", 232.0377, dic);
    dic = insert("Pa", 231.03588, dic);
    dic = insert("U", 238.02891, dic);
    dic = insert("Np", 237, dic);
    dic = insert("Pu", 244, dic);
    dic = insert("Am", 243, dic);
    dic = insert("Cm", 247, dic);
    dic = insert("Bk", 247, dic);
    dic = insert("Cf", 251, dic);
    dic = insert("Es", 252, dic);
    dic = insert("Fm", 257, dic);
    dic = insert("Uue", 315, dic);
    dic = insert("Ubn", 299, dic);
}

double lookup(string symbol) {
    for (node *ptr = dic; ptr; ptr = ptr->next) {
        if (strcmp(symbol, ptr->symbol) == 0) {
            return ptr->weight;
        }
    }

    printf("symbol not found: %s\n", symbol);
    return 0.0;
}

double total(double mass, int count) {
    if (count > 0) {
        return mass * count;
    }
    return mass;
}

double total_s(string sym, int count) {
    double mass = lookup(sym);
    return total(mass, count);
}

double evaluate_c(string expr, size_t *pos, double mass) {
    int count = 0;
    if (expr[*pos] < '0' || '9' < expr[*pos]) {
        printf("expected to find a count, saw the character: %c\n", expr[*pos]);
    }
    for (; expr[*pos]; (*pos)++) {
        char c = expr[*pos];
        if ('0' <= c && c <= '9') {
            count = count * 10 + c - '0';
        } else {
            break;
        }
    }
    return total(mass, count);
}

double evaluate_p(string expr, size_t limit, size_t *pos) {
    char sym[4];
    int sym_pos = 0;
    int count = 0;
    double sum = 0.0;

    for (; *pos < limit && expr[*pos]; (*pos)++) {
        char c = expr[*pos];
        if ('A' <= c && c <= 'Z') {
            if (sym_pos > 0) {
                sum += total_s(sym, count);
                sym_pos = 0;
                count = 0;
            }
            sym[sym_pos++] = c;
            sym[sym_pos] = 0;
        } else if ('a' <= c && c <= 'z') {
            sym[sym_pos++] = c;
            sym[sym_pos] = 0;
        } else if ('0' <= c && c <= '9') {
            count = count * 10 + c - '0';
        } else if (c == '(') {
            if (sym_pos > 0) {
                sum += total_s(sym, count);
                sym_pos = 0;
                count = 0;
            }

            (*pos)++; // skip past the paren
            double mass = evaluate_p(expr, limit, pos);

            sum += evaluate_c(expr, pos, mass);
            (*pos)--; // neutralize the position increment
        } else if (c == ')') {
            if (sym_pos > 0) {
                sum += total_s(sym, count);
                sym_pos = 0;
                count = 0;
            }

            (*pos)++;
            return sum;
        } else {
            printf("Unexpected character encountered: %c\n", c);
        }
    }

    if (sym_pos > 0) {
        sum += total_s(sym, count);
    }
    return sum;
}

double evaluate(string expr) {
    size_t limit = strlen(expr);
    size_t pos = 0;
    return evaluate_p(expr, limit, &pos);
}

void test(string expr) {
    double mass = evaluate(expr);
    printf("%17s -> %7.3f\n", expr, mass);
}

int main() {
    init();

    test("H");
    test("H2");
    test("H2O");
    test("H2O2");
    test("(HO)2");
    test("Na2SO4");
    test("C6H12");
    test("COOH(C(CH3)2)3CH3");
    test("C6H4O2(OH)4");
    test("C27H46O");
    test("Uue");

    free_node(dic);
    dic = NULL;
    return 0;
}
