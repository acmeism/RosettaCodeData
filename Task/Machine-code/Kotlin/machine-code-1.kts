// mcode.def
---

static inline unsigned char runMachineCode(void *code, unsigned char a, unsigned char b) {
    return ((unsigned char (*) (unsigned char, unsigned char))code)(a, b);
}
