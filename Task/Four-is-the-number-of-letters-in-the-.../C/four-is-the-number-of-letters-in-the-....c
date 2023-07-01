#include <ctype.h>
#include <locale.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdint.h>
#include <glib.h>

typedef uint64_t integer;

typedef struct number_names_tag {
    const char* cardinal;
    const char* ordinal;
} number_names;

const number_names small[] = {
    { "zero", "zeroth" }, { "one", "first" }, { "two", "second" },
    { "three", "third" }, { "four", "fourth" }, { "five", "fifth" },
    { "six", "sixth" }, { "seven", "seventh" }, { "eight", "eighth" },
    { "nine", "ninth" }, { "ten", "tenth" }, { "eleven", "eleventh" },
    { "twelve", "twelfth" }, { "thirteen", "thirteenth" },
    { "fourteen", "fourteenth" }, { "fifteen", "fifteenth" },
    { "sixteen", "sixteenth" }, { "seventeen", "seventeenth" },
    { "eighteen", "eighteenth" }, { "nineteen", "nineteenth" }
};

const number_names tens[] = {
    { "twenty", "twentieth" }, { "thirty", "thirtieth" },
    { "forty", "fortieth" }, { "fifty", "fiftieth" },
    { "sixty", "sixtieth" }, { "seventy", "seventieth" },
    { "eighty", "eightieth" }, { "ninety", "ninetieth" }
};

typedef struct named_number_tag {
    const char* cardinal;
    const char* ordinal;
    integer number;
} named_number;

const named_number named_numbers[] = {
    { "hundred", "hundredth", 100 },
    { "thousand", "thousandth", 1000 },
    { "million", "millionth", 1000000 },
    { "billion", "biliionth", 1000000000 },
    { "trillion", "trillionth", 1000000000000 },
    { "quadrillion", "quadrillionth", 1000000000000000ULL },
    { "quintillion", "quintillionth", 1000000000000000000ULL }
};

const char* get_small_name(const number_names* n, bool ordinal) {
    return ordinal ? n->ordinal : n->cardinal;
}

const char* get_big_name(const named_number* n, bool ordinal) {
    return ordinal ? n->ordinal : n->cardinal;
}

const named_number* get_named_number(integer n) {
    const size_t names_len = sizeof(named_numbers)/sizeof(named_numbers[0]);
    for (size_t i = 0; i + 1 < names_len; ++i) {
        if (n < named_numbers[i + 1].number)
            return &named_numbers[i];
    }
    return &named_numbers[names_len - 1];
}

typedef struct word_tag {
    size_t offset;
    size_t length;
} word_t;

typedef struct word_list_tag {
    GArray* words;
    GString* str;
} word_list;

void word_list_create(word_list* words) {
    words->words = g_array_new(FALSE, FALSE, sizeof(word_t));
    words->str = g_string_new(NULL);
}

void word_list_destroy(word_list* words) {
    g_string_free(words->str, TRUE);
    g_array_free(words->words, TRUE);
}

void word_list_clear(word_list* words) {
    g_string_truncate(words->str, 0);
    g_array_set_size(words->words, 0);
}

void word_list_append(word_list* words, const char* str) {
    size_t offset = words->str->len;
    size_t len = strlen(str);
    g_string_append_len(words->str, str, len);
    word_t word;
    word.offset = offset;
    word.length = len;
    g_array_append_val(words->words, word);
}

word_t* word_list_get(word_list* words, size_t index) {
    return &g_array_index(words->words, word_t, index);
}

void word_list_extend(word_list* words, const char* str) {
    word_t* word = word_list_get(words, words->words->len - 1);
    size_t len = strlen(str);
    word->length += len;
    g_string_append_len(words->str, str, len);
}

size_t append_number_name(word_list* words, integer n, bool ordinal) {
    size_t count = 0;
    if (n < 20) {
        word_list_append(words, get_small_name(&small[n], ordinal));
        count = 1;
    } else if (n < 100) {
        if (n % 10 == 0) {
            word_list_append(words, get_small_name(&tens[n/10 - 2], ordinal));
        } else {
            word_list_append(words, get_small_name(&tens[n/10 - 2], false));
            word_list_extend(words, "-");
            word_list_extend(words, get_small_name(&small[n % 10], ordinal));
        }
        count = 1;
    } else {
        const named_number* num = get_named_number(n);
        integer p = num->number;
        count += append_number_name(words, n/p, false);
        if (n % p == 0) {
            word_list_append(words, get_big_name(num, ordinal));
            ++count;
        } else {
            word_list_append(words, get_big_name(num, false));
            ++count;
            count += append_number_name(words, n % p, ordinal);
        }
    }
    return count;
}

size_t count_letters(word_list* words, size_t index) {
    const word_t* word = word_list_get(words, index);
    size_t letters = 0;
    const char* s = words->str->str + word->offset;
    for (size_t i = 0, n = word->length; i < n; ++i) {
        if (isalpha((unsigned char)s[i]))
            ++letters;
    }
    return letters;
}

void sentence(word_list* result, size_t count) {
    static const char* words[] = {
        "Four", "is", "the", "number", "of", "letters", "in", "the",
        "first", "word", "of", "this", "sentence,"
    };
    word_list_clear(result);
    size_t n = sizeof(words)/sizeof(words[0]);
    for (size_t i = 0; i < n; ++i)
        word_list_append(result, words[i]);
    for (size_t i = 1; count > n; ++i) {
        n += append_number_name(result, count_letters(result, i), false);
        word_list_append(result, "in");
        word_list_append(result, "the");
        n += 2;
        n += append_number_name(result, i + 1, true);
        // Append a comma to the final word
        word_list_extend(result, ",");
    }
}

size_t sentence_length(const word_list* words) {
    size_t n = words->words->len;
    if (n == 0)
        return 0;
    return words->str->len + n - 1;
}

int main() {
    setlocale(LC_ALL, "");
    size_t n = 201;
    word_list result = { 0 };
    word_list_create(&result);
    sentence(&result, n);
    printf("Number of letters in first %'lu words in the sequence:\n", n);
    for (size_t i = 0; i < n; ++i) {
        if (i != 0)
            printf("%c", i % 25 == 0 ? '\n' : ' ');
        printf("%'2lu", count_letters(&result, i));
    }
    printf("\nSentence length: %'lu\n", sentence_length(&result));
    for (n = 1000; n <= 10000000; n *= 10) {
        sentence(&result, n);
        const word_t* word = word_list_get(&result, n - 1);
        const char* s = result.str->str + word->offset;
        printf("The %'luth word is '%.*s' and has %lu letters. ", n,
               (int)word->length, s, count_letters(&result, n - 1));
        printf("Sentence length: %'lu\n" , sentence_length(&result));
    }
    word_list_destroy(&result);
    return 0;
}
