#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <string.h>
#include <stdint.h>
#include <ctype.h>

#define NELEMS(arr) (sizeof(arr) / sizeof(arr[0]))

#define da_dim(name, type)  type *name = NULL;          \
                            int _qy_ ## name ## _p = 0;  \
                            int _qy_ ## name ## _max = 0

#define da_redim(name)      do {if (_qy_ ## name ## _p >= _qy_ ## name ## _max) \
                                name = realloc(name, (_qy_ ## name ## _max += 32) * sizeof(name[0]));} while (0)

#define da_rewind(name)     _qy_ ## name ## _p = 0

#define da_append(name, x)  do {da_redim(name); name[_qy_ ## name ## _p++] = x;} while (0)

typedef unsigned char uchar;
typedef uchar code;

typedef enum { FETCH, STORE, PUSH, ADD, SUB, MUL, DIV, MOD, LT, GT, LE, GE, EQ, NE, AND,
    OR, NEG, NOT, JMP, JZ, PRTC, PRTS, PRTI, HALT
} Code_t;

typedef struct Code_map {
    char    *text;
    Code_t   op;
} Code_map;

Code_map code_map[] = {
    {"fetch",  FETCH},
    {"store",  STORE},
    {"push",   PUSH },
    {"add",    ADD  },
    {"sub",    SUB  },
    {"mul",    MUL  },
    {"div",    DIV  },
    {"mod",    MOD  },
    {"lt",     LT   },
    {"gt",     GT   },
    {"le",     LE   },
    {"ge",     GE   },
    {"eq",     EQ   },
    {"ne",     NE   },
    {"and",    AND  },
    {"or",     OR   },
    {"neg",    NEG  },
    {"not",    NOT  },
    {"jmp",    JMP  },
    {"jz",     JZ   },
    {"prtc",   PRTC },
    {"prts",   PRTS },
    {"prti",   PRTI },
    {"halt",   HALT },
};

FILE *source_fp;
da_dim(object, code);

void error(const char *fmt, ... ) {
    va_list ap;
    char buf[1000];

    va_start(ap, fmt);
    vsprintf(buf, fmt, ap);
    va_end(ap);
    printf("error: %s\n", buf);
    exit(1);
}

/*** Virtual Machine interpreter ***/
void run_vm(const code obj[], int32_t data[], int g_size, char **string_pool) {
    int32_t *sp = &data[g_size + 1];
    const code *pc = obj;

    again:
    switch (*pc++) {
        case FETCH: *sp++ = data[*(int32_t *)pc];  pc += sizeof(int32_t); goto again;
        case STORE: data[*(int32_t *)pc] = *--sp;  pc += sizeof(int32_t); goto again;
        case PUSH:  *sp++ = *(int32_t *)pc;        pc += sizeof(int32_t); goto again;
        case ADD:   sp[-2] += sp[-1]; --sp;                             goto again;
        case SUB:   sp[-2] -= sp[-1]; --sp;                             goto again;
        case MUL:   sp[-2] *= sp[-1]; --sp;                             goto again;
        case DIV:   sp[-2] /= sp[-1]; --sp;                             goto again;
        case MOD:   sp[-2] %= sp[-1]; --sp;                             goto again;
        case LT:    sp[-2] = sp[-2] <  sp[-1]; --sp;                    goto again;
        case GT:    sp[-2] = sp[-2] >  sp[-1]; --sp;                    goto again;
        case LE:    sp[-2] = sp[-2] <= sp[-1]; --sp;                    goto again;
        case GE:    sp[-2] = sp[-2] >= sp[-1]; --sp;                    goto again;
        case EQ:    sp[-2] = sp[-2] == sp[-1]; --sp;                    goto again;
        case NE:    sp[-2] = sp[-2] != sp[-1]; --sp;                    goto again;
        case AND:   sp[-2] = sp[-2] && sp[-1]; --sp;                    goto again;
        case OR:    sp[-2] = sp[-2] || sp[-1]; --sp;                    goto again;
        case NEG:   sp[-1] = -sp[-1];                                   goto again;
        case NOT:   sp[-1] = !sp[-1];                                   goto again;
        case JMP:   pc += *(int32_t *)pc;                               goto again;
        case JZ:    pc += (*--sp == 0) ? *(int32_t *)pc : (int32_t)sizeof(int32_t); goto again;
        case PRTC:  printf("%c", sp[-1]); --sp;                         goto again;
        case PRTS:  printf("%s", string_pool[sp[-1]]); --sp;            goto again;
        case PRTI:  printf("%d", sp[-1]); --sp;                         goto again;
        case HALT:                                                      break;
        default:    error("Unknown opcode %d\n", *(pc - 1));
    }
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

char *translate(char *st) {
    char *p, *q;
    if (st[0] == '"')                       // skip leading " if there
        ++st;
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
        if (q[0] == '"' && q[1] == '\0')    // skip trialing " if there
            ++q;
    }

    return st;
}

/* convert an opcode string into its byte value */
int findit(const char text[], int offset) {
    for (size_t i = 0; i < sizeof(code_map) / sizeof(code_map[0]); i++) {
        if (strcmp(code_map[i].text, text) == 0)
            return code_map[i].op;
    }
    error("Unknown instruction %s at %d\n", text, offset);
    return -1;
}

void emit_byte(int c) {
    da_append(object, (uchar)c);
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

/*
Datasize: 5 Strings: 3
" is prime\n"
"Total primes found: "
"\n"
 154 jmp    (-73) 82
 164 jz     (32) 197
 175 push  0
 159 fetch [4]
 149 store [3]
 */

/* Load code into global array object, return the string pool and data size */
char **load_code(int *ds) {
    int line_len, n_strings;
    char **string_pool;
    char *text = read_line(&line_len);
    text = rtrim(text, &line_len);

    strtok(text, " ");                      // skip "Datasize:"
    *ds = atoi(strtok(NULL, " "));          // get actual data_size
    strtok(NULL, " ");                      // skip "Strings:"
    n_strings = atoi(strtok(NULL, " "));    // get number of strings

    string_pool = malloc(n_strings * sizeof(char *));
    for (int i = 0; i < n_strings; ++i) {
        text = read_line(&line_len);
        text = rtrim(text, &line_len);
        text = translate(text);
        string_pool[i] = strdup(text);
    }

    for (;;) {
        int len;

        text = read_line(&line_len);
        if (text == NULL)
            break;
        text = rtrim(text, &line_len);

        int offset = atoi(strtok(text, " "));   // get the offset
        char *instr = strtok(NULL, " ");    // get the instruction
        int opcode = findit(instr, offset);
        emit_byte(opcode);
        char *operand = strtok(NULL, " ");

        switch (opcode) {
            case JMP: case JZ:
                operand++;                  // skip the '('
                len = strlen(operand);
                operand[len - 1] = '\0';    // remove the ')'
                emit_int(atoi(operand));
                break;
            case PUSH:
                emit_int(atoi(operand));
                break;
            case FETCH: case STORE:
                operand++;                  // skip the '['
                len = strlen(operand);
                operand[len - 1] = '\0';    // remove the ']'
                emit_int(atoi(operand));
                break;
        }
    }
    return string_pool;
}

void init_io(FILE **fp, FILE *std, const char mode[], const char fn[]) {
    if (fn[0] == '\0')
        *fp = std;
    else if ((*fp = fopen(fn, mode)) == NULL)
        error(0, 0, "Can't open %s\n", fn);
}

int main(int argc, char *argv[]) {
    init_io(&source_fp, stdin,  "r",  argc > 1 ? argv[1] : "");
    int data_size;
    char **string_pool = load_code(&data_size);
    int data[1000 + data_size];
    run_vm(object, data, data_size, string_pool);
}
