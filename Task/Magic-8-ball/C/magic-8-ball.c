#include <stdio.h>
#include <stdlib.h>
#include <time.h>

int main() {
    char *question = NULL;
    size_t len = 0;
    ssize_t read;
    const char* answers[20] = {
        "It is certain", "It is decidedly so", "Without a doubt",
        "Yes, definitely", "You may rely on it", "As I see it, yes",
        "Most likely", "Outlook good", "Signs point to yes", "Yes",
        "Reply hazy, try again", "Ask again later",
        "Better not tell you now", "Cannot predict now",
        "Concentrate and ask again", "Don't bet on it",
        "My reply is no", "My sources say no", "Outlook not so good",
        "Very doubtful"
    };
    srand(time(NULL));
    printf("Please enter your question or a blank line to quit.\n");
    while (1) {
        printf("\n? : ");
        read = getline(&question, &len, stdin);
        if (read < 2) break;
        printf("\n%s\n", answers[rand() % 20]);
    }
    if (question) free(question);
    return 0;
}
