#include <math.h>
#include <stdio.h>
#include <string.h>

int find(char *s, char c) {
    for (char *i = s; *i != 0; i++) {
        if (*i == c) {
            return i - s;
        }
    }
    return -1;
}

void reverse(char *b, char *e) {
    for (e--; b < e; b++, e--) {
        char t = *b;
        *b = *e;
        *e = t;
    }
}

//////////////////////////////////////////////////////

struct Complex {
    double rel, img;
};

void printComplex(struct Complex c) {
    printf("(%3.0f + %3.0fi)", c.rel, c.img);
}

struct Complex makeComplex(double rel, double img) {
    struct Complex c = { rel, img };
    return c;
}

struct Complex addComplex(struct Complex a, struct Complex b) {
    struct Complex c = { a.rel + b.rel, a.img + b.img };
    return c;
}

struct Complex mulComplex(struct Complex a, struct Complex b) {
    struct Complex c = { a.rel * b.rel - a.img * b.img, a.rel * b.img - a.img * b.rel };
    return c;
}

struct Complex mulComplexD(struct Complex a, double b) {
    struct Complex c = { a.rel * b, a.img * b };
    return c;
}

struct Complex negComplex(struct Complex a) {
    return mulComplexD(a, -1.0);
}

struct Complex divComplex(struct Complex a, struct Complex b) {
    double re = a.rel * b.rel + a.img * b.img;
    double im = a.img * b.rel - a.rel * b.img;
    double d = b.rel * b.rel + b.img * b.img;
    struct Complex c = { re / d, im / d };
    return c;
}

struct Complex inv(struct Complex c) {
    double d = c.rel * c.rel + c.img * c.img;
    struct Complex i = { c.rel / d, -c.img / d };
    return i;
}

const struct Complex TWO_I = { 0.0, 2.0 };
const struct Complex INV_TWO_I = { 0.0, -0.5 };

//////////////////////////////////////////////////////

struct QuaterImaginary {
    char *b2i;
    int valid;
};

struct QuaterImaginary makeQuaterImaginary(char *s) {
    struct QuaterImaginary qi = { s, 0 }; // assume invalid until tested
    size_t i, valid = 1, cnt = 0;

    if (*s != 0) {
        for (i = 0; s[i] != 0; i++) {
            if (s[i] < '0' || '3' < s[i]) {
                if (s[i] == '.') {
                    cnt++;
                } else {
                    valid = 0;
                    break;
                }
            }
        }
        if (valid && cnt > 1) {
            valid = 0;
        }
    }

    qi.valid = valid;
    return qi;
}

void printQuaterImaginary(struct QuaterImaginary qi) {
    if (qi.valid) {
        printf("%8s", qi.b2i);
    } else {
        printf(" ERROR  ");
    }
}

//////////////////////////////////////////////////////

struct Complex qi2c(struct QuaterImaginary qi) {
    size_t len = strlen(qi.b2i);
    int pointPos = find(qi.b2i, '.');
    size_t posLen = (pointPos > 0) ? pointPos : len;
    struct Complex sum = makeComplex(0.0, 0.0);
    struct Complex prod = makeComplex(1.0, 0.0);
    size_t j;

    for (j = 0; j < posLen; j++) {
        double k = qi.b2i[posLen - 1 - j] - '0';
        if (k > 0.0) {
            sum = addComplex(sum, mulComplexD(prod, k));
        }
        prod = mulComplex(prod, TWO_I);
    }
    if (pointPos != -1) {
        prod = INV_TWO_I;
        for (j = posLen + 1; j < len; j++) {
            double k = qi.b2i[j] - '0';
            if (k > 0.0) {
                sum = addComplex(sum, mulComplexD(prod, k));
            }
            prod = mulComplex(prod, INV_TWO_I);
        }
    }
    return sum;
}

// only works properly if the real and imaginary parts are integral
struct QuaterImaginary c2qi(struct Complex c, char *out) {
    char *p = out;
    int re, im, fi;

    *p = 0;
    if (c.rel == 0.0 && c.img == 0.0) {
        return makeQuaterImaginary("0");
    }

    re = (int)c.rel;
    im = (int)c.img;
    fi = -1;
    while (re != 0) {
        int rem = re % -4;
        re /= -4;
        if (rem < 0) {
            rem += 4;
            re++;
        }
        *p++ = rem + '0';
        *p++ = '0';
        *p = 0;
    }
    if (im != 0) {
        size_t index = 1;
        struct Complex fc = divComplex((struct Complex) { 0.0, c.img }, (struct Complex) { 0.0, 2.0 });
        double f = fc.rel;
        im = (int)ceil(f);
        f = -4.0 * (f - im);
        while (im != 0) {
            int rem = im % -4;
            im /= -4;
            if (rem < 0) {
                rem += 4;
                im++;
            }
            if (index < (p - out)) {
                out[index] = rem + '0';
            } else {
                *p++ = '0';
                *p++ = rem + '0';
                *p = 0;
            }
            index += 2;
        }
        fi = (int)f;
    }

    reverse(out, p);
    if (fi != -1) {
        *p++ = '.';
        *p++ = fi + '0';
        *p = 0;
    }
    while (out[0] == '0' && out[1] != '.') {
        size_t i;
        for (i = 0; out[i] != 0; i++) {
            out[i] = out[i + 1];
        }
    }
    if (*out == '.') {
        reverse(out, p);
        *p++ = '0';
        *p = 0;
        reverse(out, p);
    }
    return makeQuaterImaginary(out);
}

//////////////////////////////////////////////////////

int main() {
    char buffer[16];
    int i;

    for (i = 1; i <= 16; i++) {
        struct Complex c1 = { i, 0.0 };
        struct QuaterImaginary qi = c2qi(c1, buffer);
        struct Complex c2 = qi2c(qi);
        printComplex(c1);
        printf(" -> ");
        printQuaterImaginary(qi);
        printf(" -> ");
        printComplex(c2);

        printf("     ");

        c1 = negComplex(c1);
        qi = c2qi(c1, buffer);
        c2 = qi2c(qi);
        printComplex(c1);
        printf(" -> ");
        printQuaterImaginary(qi);
        printf(" -> ");
        printComplex(c2);

        printf("\n");
    }

    printf("\n");

    for (i = 1; i <= 16; i++) {
        struct Complex c1 = { 0.0, i };
        struct QuaterImaginary qi = c2qi(c1, buffer);
        struct Complex c2 = qi2c(qi);
        printComplex(c1);
        printf(" -> ");
        printQuaterImaginary(qi);
        printf(" -> ");
        printComplex(c2);

        printf("     ");

        c1 = negComplex(c1);
        qi = c2qi(c1, buffer);
        c2 = qi2c(qi);
        printComplex(c1);
        printf(" -> ");
        printQuaterImaginary(qi);
        printf(" -> ");
        printComplex(c2);

        printf("\n");
    }

    return 0;
}
