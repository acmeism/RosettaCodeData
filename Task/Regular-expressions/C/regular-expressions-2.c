#include <stdio.h>
#include <glib.h>

void print_regex_match(const GRegex* regex, const char* string) {
    GMatchInfo* match_info;
    gboolean match = g_regex_match(regex, string, 0, &match_info);
    printf("  string = '%s': %s\n", string, match ? "yes" : "no");
    g_match_info_free(match_info);
}

void regex_match_demo() {
    const char* pattern = "^[a-z]+$";
    GError* error = NULL;
    GRegex* regex = g_regex_new(pattern, 0, 0, &error);
    if (regex == NULL) {
        fprintf(stderr, "%s\n", error->message);
        g_error_free(error);
        return;
    }
    printf("Does the string match the pattern '%s'?\n", pattern);
    print_regex_match(regex, "test");
    print_regex_match(regex, "Test");
    g_regex_unref(regex);
}

void regex_replace_demo() {
    const char* pattern = "[0-9]";
    const char* input = "Test2";
    const char* replace = "X";
    GError* error = NULL;
    GRegex* regex = g_regex_new(pattern, 0, 0, &error);
    if (regex == NULL) {
        fprintf(stderr, "%s\n", error->message);
        g_error_free(error);
        return;
    }
    char* result = g_regex_replace_literal(regex, input, -1,
                                           0, replace, 0, &error);
    if (result == NULL) {
        fprintf(stderr, "%s\n", error->message);
        g_error_free(error);
    } else {
        printf("Replace pattern '%s' in string '%s' by '%s': '%s'\n",
               pattern, input, replace, result);
        g_free(result);
    }
    g_regex_unref(regex);
}

int main() {
    regex_match_demo();
    regex_replace_demo();
    return 0;
}
