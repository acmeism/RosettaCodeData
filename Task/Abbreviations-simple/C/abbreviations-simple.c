#include <ctype.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

const char* command_table =
  "add 1  alter 3  backup 2  bottom 1  Cappend 2  change 1  Schange  Cinsert 2  Clast 3 "
  "compress 4 copy 2 count 3 Coverlay 3 cursor 3  delete 3 Cdelete 2  down 1  duplicate "
  "3 xEdit 1 expand 3 extract 3  find 1 Nfind 2 Nfindup 6 NfUP 3 Cfind 2 findUP 3 fUP 2 "
  "forward 2  get  help 1 hexType 4  input 1 powerInput 3  join 1 split 2 spltJOIN load "
  "locate 1 Clocate 2 lowerCase 3 upperCase 3 Lprefix 2  macro  merge 2 modify 3 move 2 "
  "msg  next 1 overlay 1 parse preserve 4 purge 3 put putD query 1 quit  read recover 3 "
  "refresh renum 3 repeat 3 replace 1 Creplace 2 reset 3 restore 4 rgtLEFT right 2 left "
  "2  save  set  shift 2  si  sort  sos  stack 3 status 4 top  transfer 3  type 1  up 1";

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
        new_cmd->min_len = word_len;
        new_cmd->cmd = uppercase(word, word_len);
        if (i + 1 < count) {
            char* eptr = 0;
            unsigned long min_len = strtoul(words[i + 1], &eptr, 10);
            if (min_len > 0 && *eptr == 0) {
                free(words[i + 1]);
                new_cmd->min_len = min_len;
                ++i;
            }
        }
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
