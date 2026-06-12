#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>

struct UserInput {
    char formFeed;
    char lineFeed;
    char tab;
    char space;
};

struct UserInputNode {
    struct UserInput ui;
    struct UserInputNode *next;
};

bool decode(FILE *fp, const struct UserInput ui) {
    char f = 0, l = 0, t = 0, s = 0;
    char buffer[1];

    while (fread(buffer, 1, 1, fp)) {
        char c = buffer[0];

        if (f == ui.formFeed && l == ui.lineFeed && t == ui.tab && s == ui.space) {
            if (c == '!')
                return false;
            putchar(c);
            return true;
        } else if (c == '\f') {
            f++;
            l = t = s = 0;
        } else if (c == '\n') {
            l++;
            t = s = 0;
        } else if (c == '\t') {
            t++;
            s = 0;
        } else {
            s++;
        }
    }

    return false;
}

void decodeFile(char *fileName, struct UserInputNode *uin) {
    FILE *fp;

    fp = fopen(fileName, "r");
    if (NULL == fp) {
        fprintf(stderr, "Could not find %s\n", fileName);
        return;
    }

    if (NULL == uin) {
        fprintf(stderr, "No user input detected!\n");
        return;
    }

    while (NULL != uin) {
        if (!decode(fp, uin->ui)) {
            break;
        }
        fseek(fp, 0, SEEK_SET);
        uin = uin->next;
    }
    printf("\n\n");
}

struct UserInputNode *getUserInput() {
    struct UserInputNode *uip, *temp;

    // 0 18 0 0
    temp = malloc(sizeof(struct UserInputNode));
    temp->ui.formFeed = 0;
    temp->ui.lineFeed = 18;
    temp->ui.tab = 0;
    temp->ui.space = 0;
    uip = temp;

    // 0 68 0 1
    temp->next = malloc(sizeof(struct UserInputNode));
    temp = temp->next;
    temp->ui.formFeed = 0;
    temp->ui.lineFeed = 68;
    temp->ui.tab = 0;
    temp->ui.space = 1;

    // 0 100 0 32
    temp->next = malloc(sizeof(struct UserInputNode));
    temp = temp->next;
    temp->ui.formFeed = 0;
    temp->ui.lineFeed = 100;
    temp->ui.tab = 0;
    temp->ui.space = 32;

    // 0 114 0 45
    temp->next = malloc(sizeof(struct UserInputNode));
    temp = temp->next;
    temp->ui.formFeed = 0;
    temp->ui.lineFeed = 114;
    temp->ui.tab = 0;
    temp->ui.space = 45;

    // 0 38 0 26
    temp->next = malloc(sizeof(struct UserInputNode));
    temp = temp->next;
    temp->ui.formFeed = 0;
    temp->ui.lineFeed = 38;
    temp->ui.tab = 0;
    temp->ui.space = 26;

    // 0 16 0 21
    temp->next = malloc(sizeof(struct UserInputNode));
    temp = temp->next;
    temp->ui.formFeed = 0;
    temp->ui.lineFeed = 16;
    temp->ui.tab = 0;
    temp->ui.space = 21;

    // 0 17 0 59
    temp->next = malloc(sizeof(struct UserInputNode));
    temp = temp->next;
    temp->ui.formFeed = 0;
    temp->ui.lineFeed = 17;
    temp->ui.tab = 0;
    temp->ui.space = 59;

    // 0 11 0 29
    temp->next = malloc(sizeof(struct UserInputNode));
    temp = temp->next;
    temp->ui.formFeed = 0;
    temp->ui.lineFeed = 11;
    temp->ui.tab = 0;
    temp->ui.space = 29;

    // 0 102 0 0
    temp->next = malloc(sizeof(struct UserInputNode));
    temp = temp->next;
    temp->ui.formFeed = 0;
    temp->ui.lineFeed = 102;
    temp->ui.tab = 0;
    temp->ui.space = 0;

    // 0 10 0 50
    temp->next = malloc(sizeof(struct UserInputNode));
    temp = temp->next;
    temp->ui.formFeed = 0;
    temp->ui.lineFeed = 10;
    temp->ui.tab = 0;
    temp->ui.space = 50;

    // 0 39 0 42
    temp->next = malloc(sizeof(struct UserInputNode));
    temp = temp->next;
    temp->ui.formFeed = 0;
    temp->ui.lineFeed = 39;
    temp->ui.tab = 0;
    temp->ui.space = 42;

    // 0 33 0 50
    temp->next = malloc(sizeof(struct UserInputNode));
    temp = temp->next;
    temp->ui.formFeed = 0;
    temp->ui.lineFeed = 33;
    temp->ui.tab = 0;
    temp->ui.space = 50;

    // 0 46 0 54
    temp->next = malloc(sizeof(struct UserInputNode));
    temp = temp->next;
    temp->ui.formFeed = 0;
    temp->ui.lineFeed = 46;
    temp->ui.tab = 0;
    temp->ui.space = 54;

    // 0 76 0 47
    temp->next = malloc(sizeof(struct UserInputNode));
    temp = temp->next;
    temp->ui.formFeed = 0;
    temp->ui.lineFeed = 76;
    temp->ui.tab = 0;
    temp->ui.space = 47;

    // 0 84 2 28
    temp->next = malloc(sizeof(struct UserInputNode));
    temp = temp->next;
    temp->ui.formFeed = 0;
    temp->ui.lineFeed = 84;
    temp->ui.tab = 2;
    temp->ui.space = 28;

    temp->next = NULL;
    return uip;
}

void freeUserInput(struct UserInputNode *uip) {
    if (NULL == uip) {
        return;
    }

    freeUserInput(uip->next);
    uip->next = NULL;

    free(uip);
}

int main() {
    struct UserInputNode *uip;

    uip = getUserInput();
    decodeFile("theRaven.txt", uip);
    freeUserInput(uip);

    return 0;
}
