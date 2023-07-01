#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <glib.h>

int string_compare(gconstpointer p1, gconstpointer p2) {
    const char* const* s1 = p1;
    const char* const* s2 = p2;
    return strcmp(*s1, *s2);
}

GPtrArray* load_dictionary(const char* file, GError** error_ptr) {
    GError* error = NULL;
    GIOChannel* channel = g_io_channel_new_file(file, "r", &error);
    if (channel == NULL) {
        g_propagate_error(error_ptr, error);
        return NULL;
    }
    GPtrArray* dict = g_ptr_array_new_full(1024, g_free);
    GString* line = g_string_sized_new(64);
    gsize term_pos;
    while (g_io_channel_read_line_string(channel, line, &term_pos,
                                         &error) == G_IO_STATUS_NORMAL) {
        char* word = g_strdup(line->str);
        word[term_pos] = '\0';
        g_ptr_array_add(dict, word);
    }
    g_string_free(line, TRUE);
    g_io_channel_unref(channel);
    if (error != NULL) {
        g_propagate_error(error_ptr, error);
        g_ptr_array_free(dict, TRUE);
        return NULL;
    }
    g_ptr_array_sort(dict, string_compare);
    return dict;
}

void rotate(char* str, size_t len) {
    char c = str[0];
    memmove(str, str + 1, len - 1);
    str[len - 1] = c;
}

char* dictionary_search(const GPtrArray* dictionary, const char* word) {
    char** result = bsearch(&word, dictionary->pdata, dictionary->len,
                            sizeof(char*), string_compare);
    return result != NULL ? *result : NULL;
}

void find_teacup_words(GPtrArray* dictionary) {
    GHashTable* found = g_hash_table_new(g_str_hash, g_str_equal);
    GPtrArray* teacup_words = g_ptr_array_new();
    GString* temp = g_string_sized_new(8);
    for (size_t i = 0, n = dictionary->len; i < n; ++i) {
        char* word = g_ptr_array_index(dictionary, i);
        size_t len = strlen(word);
        if (len < 3 || g_hash_table_contains(found, word))
            continue;
        g_ptr_array_set_size(teacup_words, 0);
        g_string_assign(temp, word);
        bool is_teacup_word = true;
        for (size_t i = 0; i < len - 1; ++i) {
            rotate(temp->str, len);
            char* w = dictionary_search(dictionary, temp->str);
            if (w == NULL) {
                is_teacup_word = false;
                break;
            }
            if (strcmp(word, w) != 0 && !g_ptr_array_find(teacup_words, w, NULL))
                g_ptr_array_add(teacup_words, w);
        }
        if (is_teacup_word && teacup_words->len > 0) {
            printf("%s", word);
            g_hash_table_add(found, word);
            for (size_t i = 0; i < teacup_words->len; ++i) {
                char* teacup_word = g_ptr_array_index(teacup_words, i);
                printf(" %s", teacup_word);
                g_hash_table_add(found, teacup_word);
            }
            printf("\n");
        }
    }
    g_string_free(temp, TRUE);
    g_ptr_array_free(teacup_words, TRUE);
    g_hash_table_destroy(found);
}

int main(int argc, char** argv) {
    if (argc != 2) {
        fprintf(stderr, "usage: %s dictionary\n", argv[0]);
        return EXIT_FAILURE;
    }
    GError* error = NULL;
    GPtrArray* dictionary = load_dictionary(argv[1], &error);
    if (dictionary == NULL) {
        if (error != NULL) {
            fprintf(stderr, "Cannot load dictionary file '%s': %s\n",
                    argv[1], error->message);
            g_error_free(error);
        }
        return EXIT_FAILURE;
    }
    find_teacup_words(dictionary);
    g_ptr_array_free(dictionary, TRUE);
    return EXIT_SUCCESS;
}
