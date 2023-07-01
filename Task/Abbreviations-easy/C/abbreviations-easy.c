#include <ctype.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

const char* command_table =
  "Add ALTer  BAckup Bottom  CAppend Change SCHANGE  CInsert CLAst COMPress COpy "
  "COUnt COVerlay CURsor DELete CDelete Down DUPlicate Xedit EXPand EXTract Find "
  "NFind NFINDUp NFUp CFind FINdup FUp FOrward GET Help HEXType Input POWerinput "
  "Join SPlit SPLTJOIN  LOAD  Locate CLocate  LOWercase UPPercase  LPrefix MACRO "
  "MErge MODify MOve MSG Next Overlay PARSE PREServe PURge PUT PUTD  Query  QUIT "
  "READ  RECover REFRESH RENum REPeat  Replace CReplace  RESet  RESTore  RGTLEFT "
  "RIght LEft  SAVE  SET SHift SI  SORT  SOS  STAck STATus  TOP TRAnsfer Type Up";

typedef struct command_tag {
    char* cmd;
    size_t length;
    size_t min_len;
    struct command_tag* next;
} command_t;

// str is assumed to be all uppercase
bool command_match(const command_t* command, const char* str) {
    size_t olen = strlen(str);
    return olen >= command->min_len && olen <= command->length
        && strncmp(str, command->cmd, olen) == 0;
}

// convert string to uppercase
char* uppercase(char* str, size_t n) {
    for (size_t i = 0; i < n; ++i)
        str[i] = toupper((unsigned char)str[i]);
    return str;
}

size_t get_min_length(const char* str, size_t n) {
    size_t len = 0;
    while (len < n && isupper((unsigned char)str[len]))
        ++len;
    return len;
}

void fatal(const char* message) {
    fprintf(stderr, "%s\n", message);
    exit(1);
}

void* xmalloc(size_t n) {
    void* ptr = malloc(n);
    if (ptr == NULL)
        fatal("Out of memory");
    return ptr;
}

void* xrealloc(void* p, size_t n) {
    void* ptr = realloc(p, n);
    if (ptr == NULL)
        fatal("Out of memory");
    return ptr;
}

char** split_into_words(const char* str, size_t* count) {
    size_t size = 0;
    size_t capacity = 16;
    char** words = xmalloc(capacity * sizeof(char*));
    size_t len = strlen(str);
    for (size_t begin = 0; begin < len; ) {
        size_t i = begin;
        for (; i < len && isspace((unsigned char)str[i]); ++i) {}
        begin = i;
        for (; i < len && !isspace((unsigned char)str[i]); ++i) {}
        size_t word_len = i - begin;
        if (word_len == 0)
            break;
        char* word = xmalloc(word_len + 1);
        memcpy(word, str + begin, word_len);
        word[word_len] = 0;
        begin += word_len;
        if (capacity == size) {
            capacity *= 2;
            words = xrealloc(words, capacity * sizeof(char*));
        }
        words[size++] = word;
    }
    *count = size;
    return words;
}

command_t* make_command_list(const char* table) {
    command_t* cmd = NULL;
    size_t count = 0;
    char** words = split_into_words(table, &count);
    for (size_t i = 0; i < count; ++i) {
        char* word = words[i];
        command_t* new_cmd = xmalloc(sizeof(command_t));
        size_t word_len = strlen(word);
        new_cmd->length = word_len;
        new_cmd->min_len = get_min_length(word, word_len);
        new_cmd->cmd = uppercase(word, word_len);
        new_cmd->next = cmd;
        cmd = new_cmd;
    }
    free(words);
    return cmd;
}

void free_command_list(command_t* cmd) {
    while (cmd != NULL) {
        command_t* next = cmd->next;
        free(cmd->cmd);
        free(cmd);
        cmd = next;
    }
}

const command_t* find_command(const command_t* commands, const char* word) {
    for (const command_t* cmd = commands; cmd != NULL; cmd = cmd->next) {
        if (command_match(cmd, word))
            return cmd;
    }
    return NULL;
}

void test(const command_t* commands, const char* input) {
    printf(" input: %s\n", input);
    printf("output:");
    size_t count = 0;
    char** words = split_into_words(input, &count);
    for (size_t i = 0; i < count; ++i) {
        char* word = words[i];
        uppercase(word, strlen(word));
        const command_t* cmd_ptr = find_command(commands, word);
        printf(" %s", cmd_ptr ? cmd_ptr->cmd : "*error*");
        free(word);
    }
    free(words);
    printf("\n");
}

int main() {
    command_t* commands = make_command_list(command_table);
    const char* input = "riG   rePEAT copies  put mo   rest    types   fup.    6       poweRin";
    test(commands, input);
    free_command_list(commands);
    return 0;
}
