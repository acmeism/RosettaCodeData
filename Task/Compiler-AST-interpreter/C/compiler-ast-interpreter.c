#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <stdarg.h>
#include <ctype.h>

#define da_dim(name, type)  type *name = NULL;          \
                            int _qy_ ## name ## _p = 0;  \
                            int _qy_ ## name ## _max = 0
#define da_rewind(name)     _qy_ ## name ## _p = 0
#define da_redim(name)      do {if (_qy_ ## name ## _p >= _qy_ ## name ## _max) \
                                name = realloc(name, (_qy_ ## name ## _max += 32) * sizeof(name[0]));} while (0)
#define da_append(name, x)  do {da_redim(name); name[_qy_ ## name ## _p++] = x;} while (0)
#define da_len(name)        _qy_ ## name ## _p
#define da_add(name)        do {da_redim(name); _qy_ ## name ## _p++;} while (0)

typedef enum {
    nd_Ident, nd_String, nd_Integer, nd_Sequence, nd_If, nd_Prtc, nd_Prts, nd_Prti, nd_While,
    nd_Assign, nd_Negate, nd_Not, nd_Mul, nd_Div, nd_Mod, nd_Add, nd_Sub, nd_Lss, nd_Leq,
    nd_Gtr, nd_Geq, nd_Eql, nd_Neq, nd_And, nd_Or
} NodeType;

typedef struct Tree Tree;
struct Tree {
    NodeType node_type;
    Tree *left;
    Tree *right;
    int value;
};

// dependency: Ordered by NodeType, must remain in same order as NodeType enum

struct {
    char       *enum_text;
    NodeType   node_type;
} atr[] = {
    {"Identifier"  , nd_Ident,  },  {"String"      , nd_String,  },
    {"Integer"     , nd_Integer,},  {"Sequence"    , nd_Sequence,},
    {"If"          , nd_If,     },  {"Prtc"        , nd_Prtc,    },
    {"Prts"        , nd_Prts,   },  {"Prti"        , nd_Prti,    },
    {"While"       , nd_While,  },  {"Assign"      , nd_Assign,  },
    {"Negate"      , nd_Negate, },  {"Not"         , nd_Not,     },
    {"Multiply"    , nd_Mul,    },  {"Divide"      , nd_Div,     },
    {"Mod"         , nd_Mod,    },  {"Add"         , nd_Add,     },
    {"Subtract"    , nd_Sub,    },  {"Less"        , nd_Lss,     },
    {"LessEqual"   , nd_Leq,    },  {"Greater"     , nd_Gtr,     },
    {"GreaterEqual", nd_Geq,    },  {"Equal"       , nd_Eql,     },
    {"NotEqual"    , nd_Neq,    },  {"And"         , nd_And,     },
    {"Or"          , nd_Or,     },
};

FILE *source_fp;
da_dim(string_pool, const char *);
da_dim(global_names, const char *);
da_dim(global_values, int);

void error(const char *fmt, ... ) {
    va_list ap;
    char buf[1000];

    va_start(ap, fmt);
    vsprintf(buf, fmt, ap);
    printf("error: %s\n", buf);
    exit(1);
}

Tree *make_node(NodeType node_type, Tree *left, Tree *right) {
    Tree *t = calloc(sizeof(Tree), 1);
    t->node_type = node_type;
    t->left = left;
    t->right = right;
    return t;
}

Tree *make_leaf(NodeType node_type, int value) {
    Tree *t = calloc(sizeof(Tree), 1);
    t->node_type = node_type;
    t->value = value;
    return t;
}

int interp(Tree *x) {           /* interpret the parse tree */
    if (!x) return 0;
    switch(x->node_type) {
        case nd_Integer:  return x->value;
        case nd_Ident:    return global_values[x->value];
        case nd_String:   return x->value;

        case nd_Assign:   return global_values[x->left->value] = interp(x->right);
        case nd_Add:      return interp(x->left) +  interp(x->right);
        case nd_Sub:      return interp(x->left) -  interp(x->right);
        case nd_Mul:      return interp(x->left) *  interp(x->right);
        case nd_Div:      return interp(x->left) /  interp(x->right);
        case nd_Mod:      return interp(x->left) %  interp(x->right);
        case nd_Lss:      return interp(x->left) <  interp(x->right);
        case nd_Gtr:      return interp(x->left) >  interp(x->right);
        case nd_Leq:      return interp(x->left) <= interp(x->right);
        case nd_Eql:      return interp(x->left) == interp(x->right);
        case nd_Neq:      return interp(x->left) != interp(x->right);
        case nd_And:      return interp(x->left) && interp(x->right);
        case nd_Or:       return interp(x->left) || interp(x->right);
        case nd_Negate:   return -interp(x->left);
        case nd_Not:      return !interp(x->left);

        case nd_If:       if (interp(x->left))
                            interp(x->right->left);
                          else
                            interp(x->right->right);
                          return 0;

        case nd_While:    while (interp(x->left))
                            interp(x->right);
                          return 0;

        case nd_Prtc:     printf("%c", interp(x->left));
                          return 0;
        case nd_Prti:     printf("%d", interp(x->left));
                          return 0;
        case nd_Prts:     printf("%s", string_pool[interp(x->left)]);
                          return 0;

        case nd_Sequence: interp(x->left);
                          interp(x->right);
                          return 0;

        default:          error("interp: unknown tree type %d\n", x->node_type);
    }
    return 0;
}

void init_in(const char fn[]) {
    if (fn[0] == '\0')
        source_fp = stdin;
    else {
        source_fp = fopen(fn, "r");
        if (source_fp == NULL)
            error("Can't open %s\n", fn);
    }
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

int fetch_string_offset(char *st) {
    int len = strlen(st);
    st[len - 1] = '\0';
    ++st;
    char *p, *q;
    p = q = st;

    while ((*p++ = *q++) != '\0') {
        if (q[-1] == '\\') {
            if (q[0] == 'n') {
                p[-1] = '\n';
                ++q;
            } else if (q[0] == '\\') {
                ++q;
            }
        }
    }

    for (int i = 0; i < da_len(string_pool); ++i) {
        if (strcmp(st, string_pool[i]) == 0) {
            return i;
        }
    }
    da_add(string_pool);
    int n = da_len(string_pool) - 1;
    string_pool[n] = strdup(st);
    return da_len(string_pool) - 1;
}

int fetch_var_offset(const char *name) {
    for (int i = 0; i < da_len(global_names); ++i) {
        if (strcmp(name, global_names[i]) == 0)
            return i;
    }
    da_add(global_names);
    int n = da_len(global_names) - 1;
    global_names[n] = strdup(name);
    da_append(global_values, 0);
    return n;
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
        int n;
        for (++p; isspace(*p); ++p)
            ;
        switch (node_type) {
            case nd_Ident:      n = fetch_var_offset(p);    break;
            case nd_Integer:    n = strtol(p, NULL, 0);     break;
            case nd_String:     n = fetch_string_offset(p); break;
            default:            error("Unknown node type: %s\n", p);
        }
        return make_leaf(node_type, n);
    }

    Tree *left  = load_ast();
    Tree *right = load_ast();
    return make_node(node_type, left, right);
}

int main(int argc, char *argv[]) {
    init_in(argc > 1 ? argv[1] : "");

    Tree *x = load_ast();
    interp(x);

    return 0;
}
