#include <stdbool.h>
#include <stdio.h>
#include <glib.h>

typedef struct word_count_tag {
    const char* word;
    size_t count;
} word_count;

int compare_word_count(const void* p1, const void* p2) {
    const word_count* w1 = p1;
    const word_count* w2 = p2;
    if (w1->count > w2->count)
        return -1;
    if (w1->count < w2->count)
        return 1;
    return 0;
}

bool get_top_words(const char* filename, size_t count) {
    GError* error = NULL;
    GMappedFile* mapped_file = g_mapped_file_new(filename, FALSE, &error);
    if (mapped_file == NULL) {
        fprintf(stderr, "%s\n", error->message);
        g_error_free(error);
        return false;
    }
    const char* text = g_mapped_file_get_contents(mapped_file);
    if (text == NULL) {
        fprintf(stderr, "File %s is empty\n", filename);
        g_mapped_file_unref(mapped_file);
        return false;
    }
    gsize file_size = g_mapped_file_get_length(mapped_file);
    // Store word counts in a hash table
    GHashTable* ht = g_hash_table_new_full(g_str_hash, g_str_equal,
                                           g_free, g_free);
    GRegex* regex = g_regex_new("\\w+", 0, 0, NULL);
    GMatchInfo* match_info;
    g_regex_match_full(regex, text, file_size, 0, 0, &match_info, NULL);
    while (g_match_info_matches(match_info)) {
        char* word = g_match_info_fetch(match_info, 0);
        char* lower = g_utf8_strdown(word, -1);
        g_free(word);
        size_t* count = g_hash_table_lookup(ht, lower);
        if (count != NULL) {
            ++*count;
            g_free(lower);
        } else {
            count = g_new(size_t, 1);
            *count = 1;
            g_hash_table_insert(ht, lower, count);
        }
        g_match_info_next(match_info, NULL);
    }
    g_match_info_free(match_info);
    g_regex_unref(regex);
    g_mapped_file_unref(mapped_file);

    // Sort words in decreasing order of frequency
    size_t size = g_hash_table_size(ht);
    word_count* words = g_new(word_count, size);
    GHashTableIter iter;
    gpointer key, value;
    g_hash_table_iter_init(&iter, ht);
    for (size_t i = 0; g_hash_table_iter_next(&iter, &key, &value); ++i) {
        words[i].word = key;
        words[i].count = *(size_t*)value;
    }
    qsort(words, size, sizeof(word_count), compare_word_count);

    // Print the most common words
    if (count > size)
        count = size;
    printf("Top %lu words\n", count);
    printf("Rank\tCount\tWord\n");
    for (size_t i = 0; i < count; ++i)
        printf("%lu\t%lu\t%s\n", i + 1, words[i].count, words[i].word);
    g_free(words);
    g_hash_table_destroy(ht);
    return true;
}

int main(int argc, char** argv) {
    if (argc != 2) {
        fprintf(stderr, "usage: %s file\n", argv[0]);
        return EXIT_FAILURE;
    }
    if (!get_top_words(argv[1], 10))
        return EXIT_FAILURE;
    return EXIT_SUCCESS;
}
