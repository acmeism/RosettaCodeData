#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <stdarg.h>
#include <stdint.h>
#include <ctype.h>

typedef unsigned char uchar;

typedef enum {
    nd_Ident, nd_String, nd_Integer, nd_Sequence, nd_If, nd_Prtc, nd_Prts, nd_Prti, nd_While,
    nd_Assign, nd_Negate, nd_Not, nd_Mul, nd_Div, nd_Mod, nd_Add, nd_Sub, nd_Lss, nd_Leq,
    nd_Gtr, nd_Geq, nd_Eql, nd_Neq, nd_And, nd_Or
} NodeType;

typedef enum { FETCH, STORE, PUSH, ADD, SUB, MUL, DIV, MOD, LT, GT, LE, GE, EQ, NE, AND,
    OR, NEG, NOT, JMP, JZ, PRTC, PRTS, PRTI, HALT
} Code_t;

typedef uchar code;

typedef struct Tree {
    NodeType node_type;
    struct Tree *left;
    struct Tree *right;
    char *value;
} Tree;

#define da_dim(name, type)  type *name = NULL;          \
                            int _qy_ ## name ## _p = 0;  \
                            int _qy_ ## name ## _max = 0

#define da_redim(name)      do {if (_qy_ ## name ## _p >= _qy_ ## name ## _max) \
                                name = realloc(name, (_qy_ ## name ## _max += 32) * sizeof(name[0]));} while (0)

#define da_rewind(name)     _qy_ ## name ## _p = 0

#define da_append(name, x)  do {da_redim(name); name[_qy_ ## name ## _p++] = x;} while (0)
#define da_len(name)        _qy_ ## name ## _p
#define da_add(name)        do {da_redim(name); _qy_ ## name ## _p++;} while (0)

FILE *source_fp, *dest_fp;
static int here;
da_dim(object, code);
da_dim(globals, const char *);
da_dim(string_pool, const char *);

// dependency: Ordered by NodeType, must remain in same order as NodeType enum
struct {
    char       *enum_text;
    NodeType   node_type;
    Code_t     opcode;
} atr[] = {
    {"Identifier"  , nd_Ident,    -1 },
    {"String"      , nd_String,   -1 },
    {"Integer"     , nd_Integer,  -1 },
    {"Sequence"    , nd_Sequence, -1 },
    {"If"          , nd_If,       -1 },
    {"Prtc"        , nd_Prtc,     -1 },
    {"Prts"        , nd_Prts,     -1 },
    {"Prti"        , nd_Prti,     -1 },
    {"While"       , nd_While,    -1 },
    {"Assign"      , nd_Assign,   -1 },
    {"Negate"      , nd_Negate,   NEG},
    {"Not"         , nd_Not,      NOT},
    {"Multiply"    , nd_Mul,      MUL},
    {"Divide"      , nd_Div,      DIV},
    {"Mod"         , nd_Mod,      MOD},
    {"Add"         , nd_Add,      ADD},
    {"Subtract"    , nd_Sub,      SUB},
    {"Less"        , nd_Lss,      LT },
    {"LessEqual"   , nd_Leq,      LE },
    {"Greater"     , nd_Gtr,      GT },
    {"GreaterEqual", nd_Geq,      GE },
    {"Equal"       , nd_Eql,      EQ },
    {"NotEqual"    , nd_Neq,      NE },
    {"And"         , nd_And,      AND},
    {"Or"          , nd_Or,       OR },
};

void error(const char *fmt, ... ) {
    va_list ap;
    char buf[1000];

    va_start(ap, fmt);
    vsprintf(buf, fmt, ap);
    va_end(ap);
    printf("error: %s\n", buf);
    exit(1);
}

Code_t type_to_op(NodeType type) {
    return atr[type].opcode;
}

Tree *make_node(NodeType node_type, Tree *left, Tree *right) {
    Tree *t = calloc(sizeof(Tree), 1);
    t->node_type = node_type;
    t->left = left;
    t->right = right;
    return t;
}

Tree *make_leaf(NodeType node_type, char *value) {
    Tree *t = calloc(sizeof(Tree), 1);
    t->node_type = node_type;
    t->value = strdup(value);
    return t;
}

/*** Code generator ***/

void emit_byte(int c) {
    da_append(object, (uchar)c);
    ++here;
}

void emit_int(int32_t n) {
    union {
        int32_t n;
        unsigned char c[sizeof(int32_t)];
    } x;

    x.n = n;

    for (size_t i = 0; i < sizeof(x.n); ++i) {
        emit_byte(x.c[i]);
    }
}

int hole() {
    int t = here;
    emit_int(0);
    return t;
}

void fix(int src, int dst) {
    *(int32_t *)(object + src) = dst-src;
}

int fetch_var_offset(const char *id) {
    for (int i = 0; i < da_len(globals); ++i) {
        if (strcmp(id, globals[i]) == 0)
            return i;
    }
    da_add(globals);
    int n = da_len(globals) - 1;
    globals[n] = strdup(id);
    return n;
}

int fetch_string_offset(const char *st) {
    for (int i = 0; i < da_len(string_pool); ++i) {
        if (strcmp(st, string_pool[i]) == 0)
            return i;
    }
    da_add(string_pool);
    int n = da_len(string_pool) - 1;
    string_pool[n] = strdup(st);
    return n;
}

void code_gen(Tree *x) {
    int p1, p2, n;

    if (x == NULL) return;
    switch (x->node_type) {
        case nd_Ident:
            emit_byte(FETCH);
            n = fetch_var_offset(x->value);
            emit_int(n);
            break;
        case nd_Integer:
            emit_byte(PUSH);
            emit_int(atoi(x->value));
            break;
        case nd_String:
            emit_byte(PUSH);
            n = fetch_string_offset(x->value);
            emit_int(n);
            break;
        case nd_Assign:
            n = fetch_var_offset(x->left->value);
            code_gen(x->right);
            emit_byte(STORE);
            emit_int(n);
            break;
        case nd_If:
            code_gen(x->left);        // if expr
            emit_byte(JZ);                  // if false, jump
            p1 = hole();                    // make room for jump dest
            code_gen(x->right->left);   // if true statements
            if (x->right->right != NULL) {
                emit_byte(JMP);
                p2 = hole();
            }
            fix(p1, here);
            if (x->right->right != NULL) {
                code_gen(x->right->right);
                fix(p2, here);
            }
            break;
        case nd_While:
            p1 = here;
            code_gen(x->left);        // while expr
            emit_byte(JZ);                  // if false, jump
            p2 = hole();                    // make room for jump dest
            code_gen(x->right);       // statements
            emit_byte(JMP);                 // back to the top
            fix(hole(), p1);                // plug the top
            fix(p2, here);                  // plug the 'if false, jump'
            break;
        case nd_Sequence:
            code_gen(x->left);
            code_gen(x->right);
            break;
        case nd_Prtc:
            code_gen(x->left);
            emit_byte(PRTC);
            break;
        case nd_Prti:
            code_gen(x->left);
            emit_byte(PRTI);
            break;
        case nd_Prts:
            code_gen(x->left);
            emit_byte(PRTS);
            break;
        case nd_Lss: case nd_Gtr: case nd_Leq: case nd_Geq: case nd_Eql: case nd_Neq:
        case nd_And: case nd_Or: case nd_Sub: case nd_Add: case nd_Div: case nd_Mul:
        case nd_Mod:
            code_gen(x->left);
            code_gen(x->right);
            emit_byte(type_to_op(x->node_type));
            break;
        case nd_Negate: case nd_Not:
            code_gen(x->left);
            emit_byte(type_to_op(x->node_type));
            break;
        default:
            error("error in code generator - found %d, expecting operator\n", x->node_type);
    }
}

void code_finish() {
    emit_byte(HALT);
}

void list_code() {
    fprintf(dest_fp, "Datasize: %d Strings: %d\n", da_len(globals), da_len(string_pool));
    for (int i = 0; i < da_len(string_pool); ++i)
        fprintf(dest_fp, "%s\n", string_pool[i]);

    code *pc = object;

    again: fprintf(dest_fp, "%5d ", (int)(pc - object));
    switch (*pc++) {
        case FETCH: fprintf(dest_fp, "fetch [%d]\n", *(int32_t *)pc);
                    pc += sizeof(int32_t);  goto again;
        case STORE: fprintf(dest_fp, "store [%d]\n", *(int32_t *)pc);
                    pc += sizeof(int32_t);  goto again;
        case PUSH : fprintf(dest_fp, "push  %d\n", *(int32_t *)pc);
                    pc += sizeof(int32_t);    goto again;
        case ADD  : fprintf(dest_fp, "add\n");      goto again;
        case SUB  : fprintf(dest_fp, "sub\n");      goto again;
        case MUL  : fprintf(dest_fp, "mul\n");      goto again;
        case DIV  : fprintf(dest_fp, "div\n");      goto again;
        case MOD  : fprintf(dest_fp, "mod\n");      goto again;
        case LT   : fprintf(dest_fp, "lt\n");       goto again;
        case GT   : fprintf(dest_fp, "gt\n");       goto again;
        case LE   : fprintf(dest_fp, "le\n");       goto again;
        case GE   : fprintf(dest_fp, "ge\n");       goto again;
        case EQ   : fprintf(dest_fp, "eq\n");       goto again;
        case NE   : fprintf(dest_fp, "ne\n");       goto again;
        case AND  : fprintf(dest_fp, "and\n");      goto again;
        case OR   : fprintf(dest_fp, "or\n");       goto again;
        case NOT  : fprintf(dest_fp, "not\n");      goto again;
        case NEG  : fprintf(dest_fp, "neg\n");      goto again;
        case JMP  : fprintf(dest_fp, "jmp    (%d) %d\n",
                        *(int32_t *)pc, (int32_t)(pc + *(int32_t *)pc - object));
                    pc += sizeof(int32_t); goto again;
        case JZ   : fprintf(dest_fp, "jz     (%d) %d\n",
                        *(int32_t *)pc, (int32_t)(pc + *(int32_t *)pc - object));
                    pc += sizeof(int32_t); goto again;
        case PRTC : fprintf(dest_fp, "prtc\n");     goto again;
        case PRTI : fprintf(dest_fp, "prti\n");     goto again;
        case PRTS : fprintf(dest_fp, "prts\n");     goto again;
        case HALT : fprintf(dest_fp, "halt\n");     break;
        default:error("listcode:Unknown opcode %d\n", *(pc - 1));
    }
}

void init_io(FILE **fp, FILE *std, const char mode[], const char fn[]) {
    if (fn[0] == '\0')
        *fp = std;
    else if ((*fp = fopen(fn, mode)) == NULL)
        error(0, 0, "Can't open %s\n", fn);
}

NodeType get_enum_value(const char name[]) {
    for (size_t i = 0; i < sizeof(atr) / sizeof(atr[0]); i++) {
        if (strcmp(atr[i].enum_text, name) == 0) {
            return atr[i].node_type;
        }
    }
    error("Unknown token %s\n", name);
    return -1;
}

char *read_line(int *len) {
    static char *text = NULL;
    static int textmax = 0;

    for (*len = 0; ; (*len)++) {
        int ch = fgetc(source_fp);
        if (ch == EOF || ch == '\n') {
            if (*len == 0)
                return NULL;
            break;
        }
        if (*len + 1 >= textmax) {
            textmax = (textmax == 0 ? 128 : textmax * 2);
            text = realloc(text, textmax);
        }
        text[*len] = ch;
    }
    text[*len] = '\0';
    return text;
}

char *rtrim(char *text, int *len) {         // remove trailing spaces
    for (; *len > 0 && isspace(text[*len - 1]); --(*len))
        ;

    text[*len] = '\0';
    return text;
}

Tree *load_ast() {
    int len;
    char *yytext = read_line(&len);
    yytext = rtrim(yytext, &len);

    // get first token
    char *tok = strtok(yytext, " ");

    if (tok[0] == ';') {
        return NULL;
    }
    NodeType node_type = get_enum_value(tok);

    // if there is extra data, get it
    char *p = tok + strlen(tok);
    if (p != &yytext[len]) {
        for (++p; isspace(*p); ++p)
            ;
        return make_leaf(node_type, p);
    }

    Tree *left  = load_ast();
    Tree *right = load_ast();
    return make_node(node_type, left, right);
}

int main(int argc, char *argv[]) {
    init_io(&source_fp, stdin,  "r",  argc > 1 ? argv[1] : "");
    init_io(&dest_fp,   stdout, "wb", argc > 2 ? argv[2] : "");

    code_gen(load_ast());
    code_finish();
    list_code();

    return 0;
}
