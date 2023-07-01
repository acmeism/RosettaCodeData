#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <glib.h>

char text_char(char c) {
    switch (c) {
    case 'a': case 'b': case 'c':
        return '2';
    case 'd': case 'e': case 'f':
        return '3';
    case 'g': case 'h': case 'i':
        return '4';
    case 'j': case 'k': case 'l':
        return '5';
    case 'm': case 'n': case 'o':
        return '6';
    case 'p': case 'q': case 'r': case 's':
        return '7';
    case 't': case 'u': case 'v':
        return '8';
    case 'w': case 'x': case 'y': case 'z':
        return '9';
    default:
        return 0;
    }
}

bool text_string(const GString* word, GString* text) {
    g_string_set_size(text, word->len);
    for (size_t i = 0; i < word->len; ++i) {
        char c = text_char(g_ascii_tolower(word->str[i]));
        if (c == 0)
            return false;
        text->str[i] = c;
    }
    return true;
}

typedef struct textonym_tag {
    const char* text;
    size_t length;
    GPtrArray* words;
} textonym_t;

int compare_by_text_length(const void* p1, const void* p2) {
    const textonym_t* t1 = p1;
    const textonym_t* t2 = p2;
    if (t1->length > t2->length)
        return -1;
    if (t1->length < t2->length)
        return 1;
    return strcmp(t1->text, t2->text);
}

int compare_by_word_count(const void* p1, const void* p2) {
    const textonym_t* t1 = p1;
    const textonym_t* t2 = p2;
    if (t1->words->len > t2->words->len)
        return -1;
    if (t1->words->len < t2->words->len)
        return 1;
    return strcmp(t1->text, t2->text);
}

void print_words(GPtrArray* words) {
    for (guint i = 0, n = words->len; i < n; ++i) {
        if (i > 0)
            printf(", ");
        printf("%s", g_ptr_array_index(words, i));
    }
    printf("\n");
}

void print_top_words(GArray* textonyms, guint top) {
    for (guint i = 0; i < top; ++i) {
        const textonym_t* t = &g_array_index(textonyms, textonym_t, i);
        printf("%s = ", t->text);
        print_words(t->words);
    }
}

void free_strings(gpointer ptr) {
    g_ptr_array_free(ptr, TRUE);
}

bool find_textonyms(const char* filename, GError** error_ptr) {
    GError* error = NULL;
    GIOChannel* channel = g_io_channel_new_file(filename, "r", &error);
    if (channel == NULL) {
        g_propagate_error(error_ptr, error);
        return false;
    }
    GHashTable* ht = g_hash_table_new_full(g_str_hash, g_str_equal,
                                           g_free, free_strings);
    GString* word = g_string_sized_new(64);
    GString* text = g_string_sized_new(64);
    guint count = 0;
    gsize term_pos;
    while (g_io_channel_read_line_string(channel, word, &term_pos,
                                         &error) == G_IO_STATUS_NORMAL) {
        g_string_truncate(word, term_pos);
        if (!text_string(word, text))
            continue;
        GPtrArray* words = g_hash_table_lookup(ht, text->str);
        if (words == NULL) {
            words = g_ptr_array_new_full(1, g_free);
            g_hash_table_insert(ht, g_strdup(text->str), words);
        }
        g_ptr_array_add(words, g_strdup(word->str));
        ++count;
    }
    g_io_channel_unref(channel);
    g_string_free(word, TRUE);
    g_string_free(text, TRUE);
    if (error != NULL) {
        g_propagate_error(error_ptr, error);
        g_hash_table_destroy(ht);
        return false;
    }

    GArray* words = g_array_new(FALSE, FALSE, sizeof(textonym_t));
    GHashTableIter iter;
    gpointer key, value;
    g_hash_table_iter_init(&iter, ht);
    while (g_hash_table_iter_next(&iter, &key, &value)) {
        GPtrArray* v = value;
        if (v->len > 1) {
            textonym_t textonym;
            textonym.text = key;
            textonym.length = strlen(key);
            textonym.words = v;
            g_array_append_val(words, textonym);
        }
    }

    printf("There are %u words in '%s' which can be represented by the digit key mapping.\n",
           count, filename);
    guint size = g_hash_table_size(ht);
    printf("They require %u digit combinations to represent them.\n", size);
    guint textonyms = words->len;
    printf("%u digit combinations represent Textonyms.\n", textonyms);

    guint top = 5;
    if (textonyms < top)
        top = textonyms;

    printf("\nTop %u by number of words:\n", top);
    g_array_sort(words, compare_by_word_count);
    print_top_words(words, top);

    printf("\nTop %u by length:\n", top);
    g_array_sort(words, compare_by_text_length);
    print_top_words(words, top);

    g_array_free(words, TRUE);
    g_hash_table_destroy(ht);
    return true;
}

int main(int argc, char** argv) {
    if (argc != 2) {
        fprintf(stderr, "usage: %s word-list\n", argv[0]);
        return EXIT_FAILURE;
    }
    GError* error = NULL;
    if (!find_textonyms(argv[1], &error)) {
        if (error != NULL) {
            fprintf(stderr, "%s: %s\n", argv[1], error->message);
            g_error_free(error);
        }
        return EXIT_FAILURE;
    }
    return EXIT_SUCCESS;
}
