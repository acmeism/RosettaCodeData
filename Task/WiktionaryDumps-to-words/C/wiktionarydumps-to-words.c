#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>
#include <unistd.h>

#include <expat.h>
#include <pcre.h>

#ifdef XML_LARGE_SIZE
#  define XML_FMT_INT_MOD "ll"
#else
#  define XML_FMT_INT_MOD "l"
#endif

#ifdef XML_UNICODE_WCHAR_T
#  define XML_FMT_STR "ls"
#else
#  define XML_FMT_STR "s"
#endif

void reset_char_data_buffer();
void process_char_data_buffer();

static bool last_tag_is_title;
static bool last_tag_is_text;

static pcre *reCompiled;
static pcre_extra *pcreExtra;


void start_element(void *data, const char *element, const char **attribute) {
    process_char_data_buffer();
    reset_char_data_buffer();

    if (strcmp("title", element) == 0) {
        last_tag_is_title = true;
    }
    if (strcmp("text", element) == 0) {
        last_tag_is_text = true;
    }
}

void end_element(void *data, const char *el) {
    process_char_data_buffer();
    reset_char_data_buffer();
}


#define TITLE_BUF_SIZE (1024 * 8)

static char char_data_buffer[1024 * 64 * 8];
static char title_buffer[TITLE_BUF_SIZE];
static size_t offs;
static bool overflow;


void reset_char_data_buffer(void) {
    offs = 0;
    overflow = false;
}

// pastes parts of the node together
void char_data(void *userData, const XML_Char *s, int len) {
    if (!overflow) {
        if (len + offs >= sizeof(char_data_buffer)) {
            overflow = true;
            fprintf(stderr, "Warning: buffer overflow\n");
            fflush(stderr);
        } else {
            memcpy(char_data_buffer + offs, s, len);
            offs += len;
        }
    }
}

void try_match();

// if the element is the one we're after
void process_char_data_buffer(void) {
    if (offs > 0) {
        char_data_buffer[offs] = '\0';

        if (last_tag_is_title) {
            unsigned int n = (offs+1 > TITLE_BUF_SIZE) ? TITLE_BUF_SIZE : (offs+1);
            memcpy(title_buffer, char_data_buffer, n);
            last_tag_is_title = false;
        }
        if (last_tag_is_text) {
            try_match();
            last_tag_is_text = false;
        }
    }
}

void try_match()
{
    int subStrVec[80];
    int subStrVecLen;
    int pcreExecRet;
    subStrVecLen = sizeof(subStrVec) / sizeof(int);

    pcreExecRet = pcre_exec(
            reCompiled, pcreExtra,
            char_data_buffer, strlen(char_data_buffer),
            0, 0,
            subStrVec, subStrVecLen);

    if (pcreExecRet < 0) {
        switch (pcreExecRet) {
            case PCRE_ERROR_NOMATCH      : break;
            case PCRE_ERROR_NULL         : fprintf(stderr, "Something was null\n");                      break;
            case PCRE_ERROR_BADOPTION    : fprintf(stderr, "A bad option was passed\n");                 break;
            case PCRE_ERROR_BADMAGIC     : fprintf(stderr, "Magic number bad (compiled re corrupt?)\n"); break;
            case PCRE_ERROR_UNKNOWN_NODE : fprintf(stderr, "Something kooky in the compiled re\n");      break;
            case PCRE_ERROR_NOMEMORY     : fprintf(stderr, "Ran out of memory\n");                       break;
            default                      : fprintf(stderr, "Unknown error\n");                           break;
        }
    } else {
        puts(title_buffer);  // print the word
    }
}


#define BUF_SIZE 1024

int main(int argc, char *argv[])
{
    char buffer[BUF_SIZE];
    int n;

    const char *pcreErrorStr;
    int pcreErrorOffset;
    char *aStrRegex;
    char **aLineToMatch;

    // Using PCRE

    aStrRegex = "(.*)(==French==)(.*)";  // search for French language

    reCompiled = pcre_compile(aStrRegex, PCRE_DOTALL | PCRE_UTF8, &pcreErrorStr, &pcreErrorOffset, NULL);
    if (reCompiled == NULL) {
        fprintf(stderr, "ERROR: Could not compile regex '%s': %s\n", aStrRegex, pcreErrorStr);
        exit(1);
    }

    pcreExtra = pcre_study(reCompiled, 0, &pcreErrorStr);
    if (pcreErrorStr != NULL) {
        fprintf(stderr, "ERROR: Could not study regex '%s': %s\n", aStrRegex, pcreErrorStr);
        exit(1);
    }

    // Using Expat parser

    XML_Parser parser = XML_ParserCreate(NULL);

    XML_SetElementHandler(parser, start_element, end_element);
    XML_SetCharacterDataHandler(parser, char_data);

    reset_char_data_buffer();

    while (1) {
        int done;
        int len;

        len = (int)fread(buffer, 1, BUF_SIZE, stdin);
        if (ferror(stdin)) {
            fprintf(stderr, "Read error\n");
            exit(1);
        }
        done = feof(stdin);

        if (XML_Parse(parser, buffer, len, done) == XML_STATUS_ERROR) {
            fprintf(stderr,
                "Parse error at line %" XML_FMT_INT_MOD "u:\n%" XML_FMT_STR "\n",
                XML_GetCurrentLineNumber(parser),
                XML_ErrorString(XML_GetErrorCode(parser)));
            exit(1);
        }

        if (done) break;
    }

    XML_ParserFree(parser);

    pcre_free(reCompiled);

    if (pcreExtra != NULL) {
#ifdef PCRE_CONFIG_JIT
        pcre_free_study(pcreExtra);
#else
        pcre_free(pcreExtra);
#endif
    }

    return 0;
}
