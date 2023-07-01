#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef char const *const string;

bool consume_sentinal(bool middle, string s, size_t *pos) {
    if (middle) {
        if (s[*pos] == ' ' && s[*pos + 1] == '#' && s[*pos + 2] == ' ' && s[*pos + 3] == '#' && s[*pos + 4] == ' ') {
            *pos += 5;
            return true;
        }
    } else {
        if (s[*pos] == '#' && s[*pos + 1] == ' ' && s[*pos + 2] == '#') {
            *pos += 3;
            return true;
        }
    }
    return false;
}

int consume_digit(bool right, string s, size_t *pos) {
    const char zero = right ? '#' : ' ';
    const char one = right ? ' ' : '#';
    size_t i = *pos;
    int result = -1;

    if (s[i] == zero) {
        if (s[i + 1] == zero) {
            if (s[i + 2] == zero) {
                if (s[i + 3] == one) {
                    if (s[i + 4] == zero) {
                        if (s[i + 5] == one && s[i + 6] == one) {
                            result = 9;
                        }
                    } else if (s[i + 4] == one) {
                        if (s[i + 5] == zero && s[i + 6] == one) {
                            result = 0;
                        }
                    }
                }
            } else if (s[i + 2] == one) {
                if (s[i + 3] == zero) {
                    if (s[i + 4] == zero && s[i + 5] == one && s[i + 6] == one) {
                        result = 2;
                    }
                } else if (s[i + 3] == one) {
                    if (s[i + 4] == zero && s[i + 5] == zero && s[i + 6] == one) {
                        result = 1;
                    }
                }
            }
        } else if (s[i + 1] == one) {
            if (s[i + 2] == zero) {
                if (s[i + 3] == zero) {
                    if (s[i + 4] == zero && s[i + 5] == one && s[i + 6] == one) {
                        result = 4;
                    }
                } else if (s[i + 3] == one) {
                    if (s[i + 4] == one && s[i + 5] == one && s[i + 6] == one) {
                        result = 6;
                    }
                }
            } else if (s[i + 2] == one) {
                if (s[i + 3] == zero) {
                    if (s[i + 4] == zero) {
                        if (s[i + 5] == zero && s[i + 6] == one) {
                            result = 5;
                        }
                    } else if (s[i + 4] == one) {
                        if (s[i + 5] == one && s[i + 6] == one) {
                            result = 8;
                        }
                    }
                } else if (s[i + 3] == one) {
                    if (s[i + 4] == zero) {
                        if (s[i + 5] == one && s[i + 6] == one) {
                            result = 7;
                        }
                    } else if (s[i + 4] == one) {
                        if (s[i + 5] == zero && s[i + 6] == one) {
                            result = 3;
                        }
                    }
                }
            }
        }
    }

    if (result >= 0) {
        *pos += 7;
    }
    return result;
}

bool decode_upc(string src, char *buffer) {
    const int one = 1;
    const int three = 3;

    size_t pos = 0;
    int sum = 0;
    int digit;

    //1) 9 spaces (unreliable)
    while (src[pos] != '#') {
        if (src[pos] == 0) {
            return false;
        }
        pos++;
    }

    //2) Start "# #"
    if (!consume_sentinal(false, src, &pos)) {
        return false;
    }

    //3) 6 left-hand digits (space is zero and hash is one)
    digit = consume_digit(false, src, &pos);
    if (digit < 0) {
        return false;
    }
    sum += three * digit;
    *buffer++ = digit + '0';
    *buffer++ = ' ';

    digit = consume_digit(false, src, &pos);
    if (digit < 0) {
        return false;
    }
    sum += one * digit;
    *buffer++ = digit + '0';
    *buffer++ = ' ';

    digit = consume_digit(false, src, &pos);
    if (digit < 0) {
        return false;
    }
    sum += three * digit;
    *buffer++ = digit + '0';
    *buffer++ = ' ';

    digit = consume_digit(false, src, &pos);
    if (digit < 0) {
        return false;
    }
    sum += one * digit;
    *buffer++ = digit + '0';
    *buffer++ = ' ';

    digit = consume_digit(false, src, &pos);
    if (digit < 0) {
        return false;
    }
    sum += three * digit;
    *buffer++ = digit + '0';
    *buffer++ = ' ';

    digit = consume_digit(false, src, &pos);
    if (digit < 0) {
        return false;
    }
    sum += one * digit;
    *buffer++ = digit + '0';
    *buffer++ = ' ';

    //4) Middle "# #"
    if (!consume_sentinal(true, src, &pos)) {
        return false;
    }

    //5) 6 right-hand digits (hash is zero and space is one)
    digit = consume_digit(true, src, &pos);
    if (digit < 0) {
        return false;
    }
    sum += three * digit;
    *buffer++ = digit + '0';
    *buffer++ = ' ';

    digit = consume_digit(true, src, &pos);
    if (digit < 0) {
        return false;
    }
    sum += one * digit;
    *buffer++ = digit + '0';
    *buffer++ = ' ';

    digit = consume_digit(true, src, &pos);
    if (digit < 0) {
        return false;
    }
    sum += three * digit;
    *buffer++ = digit + '0';
    *buffer++ = ' ';

    digit = consume_digit(true, src, &pos);
    if (digit < 0) {
        return false;
    }
    sum += one * digit;
    *buffer++ = digit + '0';
    *buffer++ = ' ';

    digit = consume_digit(true, src, &pos);
    if (digit < 0) {
        return false;
    }
    sum += three * digit;
    *buffer++ = digit + '0';
    *buffer++ = ' ';

    digit = consume_digit(true, src, &pos);
    if (digit < 0) {
        return false;
    }
    sum += one * digit;
    *buffer++ = digit + '0';
    *buffer++ = ' ';

    //6) Final "# #"
    if (!consume_sentinal(false, src, &pos)) {
        return false;
    }

    //7) 9 spaces (unreliable)
    // skip

    //8) the dot product of the number and (3, 1)+ sequence mod 10 must be zero
    return sum % 10 == 0;
}

void test(string src) {
    char buffer[24];

    if (decode_upc(src, buffer)) {
        buffer[22] = 0;
        printf("%sValid\n", buffer);
    } else {
        size_t len = strlen(src);
        char *rev = malloc(len + 1);
        size_t i;

        if (rev == NULL) {
            exit(1);
        }

        for (i = 0; i < len; i++) {
            rev[i] = src[len - i - 1];
        }

#pragma warning(push)
#pragma warning(disable : 6386)
        // if len + 1 bytes are allocated, and len bytes are writable, there is no buffer overrun
        rev[len] = 0;
#pragma warning(pop)

        if (decode_upc(rev, buffer)) {
            buffer[22] = 0;
            printf("%sValid (upside down)\n", buffer);
        } else {
            printf("Invalid digit(s)\n");
        }

        free(rev);
    }
}

int main() {
    int num = 0;

    printf("%2d: ", ++num);
    test("         # #   # ##  #  ## #   ## ### ## ### ## #### # # # ## ##  #   #  ##  ## ###  # ##  ## ### #  # #       ");

    printf("%2d: ", ++num);
    test("        # # #   ##   ## # #### #   # ## #   ## #   ## # # # ###  # ###  ##  ## ###  # #  ### ###  # # #         ");

    printf("%2d: ", ++num);
    test("         # #    # # #  ###  #   #    # #  #   #    # # # # ## #   ## #   ## #   ##   # # #### ### ## # #         ");

    printf("%2d: ", ++num);
    test("       # # ##  ## ##  ##   #  #   #  # ###  # ##  ## # # #   ## ##  #  ### ## ## #   # #### ## #   # #        ");

    printf("%2d: ", ++num);
    test("         # # ### ## #   ## ## ###  ##  # ##   #   # ## # # ### #  ## ##  #    # ### #  ## ##  #      # #          ");

    printf("%2d: ", ++num);
    test("          # #  #   # ##  ##  #   #   #  # ##  ##  #   # # # # #### #  ##  # #### #### # #  ##  # #### # #         ");

    printf("%2d: ", ++num);
    test("         # #  #  ##  ##  # #   ## ##   # ### ## ##   # # # #  #   #   #  #  ### # #    ###  # #  #   # #        ");

    printf("%2d: ", ++num);
    test("        # # #    # ##  ##   #  # ##  ##  ### #   #  # # # ### ## ## ### ## ### ### ## #  ##  ### ## # #         ");

    printf("%2d: ", ++num);
    test("         # # ### ##   ## # # #### #   ## # #### # #### # # #   #  # ###  #    # ###  # #    # ###  # # #       ");

    printf("%2d: ", ++num);
    test("        # # # #### ##   # #### # #   ## ## ### #### # # # #  ### # ###  ###  # # ###  #    # #  ### # #         ");

    return 0;
}
