#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define DEFAULT_LENGTH 4
#define DEFAULT_COUNT 1

char* symbols[] = {"ABCDEFGHIJKLMNOPQRSTUVWXYZ", "abcdefghijklmnopqrstuvwxyz", "0123456789", "!\"#$%&'()*+,-./:;<=>?@[]^_{|}~"};
int length = DEFAULT_LENGTH;
int count = DEFAULT_COUNT;
unsigned seed;
char exSymbols = 0;

void GetPassword () {
    //create an array of values that determine the number of characters from each category
    int lengths[4] = {1, 1, 1, 1};
    int count = 4;
    while (count < length) {
        lengths[rand()%4]++;
        count++;
    }

    //loop through the array of lengths and set the characters in password
    char password[length + 1];
    for (int i = 0; i < length; ) {
        //pick which string to read from
        int str = rand()%4;
        if (!lengths[str])continue;   //if the number of characters for that string have been reached, continue to the next interation

        char c;
        switch (str) {
            case 2:
                c = symbols[str][rand()%10];
                while (exSymbols && (c == 'I' || c == 'l' || c == '1' || c == 'O' || c == '0' || c == '5' || c == 'S' || c == '2' || c == 'Z'))
                    c = symbols[str][rand()%10];
                password[i] = c;
            break;

            case 3:
                c = symbols[str][rand()%30];
                while (exSymbols && (c == 'I' || c == 'l' || c == '1' || c == 'O' || c == '0' || c == '5' || c == 'S' || c == '2' || c == 'Z'))
                    c = symbols[str][rand()%30];
                password[i] = c;
            break;

            default:
                c = symbols[str][rand()%26];
                while (exSymbols && (c == 'I' || c == 'l' || c == '1' || c == 'O' || c == '0' || c == '5' || c == 'S' || c == '2' || c == 'Z'))
                    c = symbols[str][rand()%26];
                password[i] = c;
            break;
        }

        i++;
        lengths[str]--;
    }

    password [length] = '\0';
    printf ("%s\n", password);
}

int main (int argc, char* argv[]) {
    seed = (unsigned)time(NULL);

    //handle user input from the command line
    for (int i = 1; i < argc; i++) {
        switch (argv[i][1]) {
            case 'l':
                if (sscanf (argv[i+1], "%d", &length) != 1) {
                    puts ("Unrecognized input. Syntax: -l [integer]");
                    return -1;
                }

                if (length < 4) {
                    puts ("Password length must be at least 4 characters.");
                    return -1;
                }
                i++;
            break;

            case 'c':
                if (sscanf (argv[i+1], "%d", &count) != 1) {
                    puts ("Unrecognized input. Syntax: -c [integer]");
                    return -1;
                }

                if (count <= 0) {
                    puts ("Count must be at least 1.");
                    return -1;
                }
                i++;
            break;

            case 's':
                if (sscanf (argv[i+1], "%d", &seed) != 1) {
                    puts ("Unrecognized input. Syntax: -s [integer]");
                    return -1;
                }
                i++;
            break;

            case 'e':
                exSymbols = 1;
            break;

            default:
                help:
                printf ("Help:\nThis program generates a random password.\n"
                "Commands:"
                   "Set password length: -l [integer]\n"
                   "Set password count: -c [integer]\n"
                   "Set seed: -s [integer]\n"
                   "Exclude similiar characters: -e\n"
                   "Display help: -h");
                return 0;
            break;
        }
    }

    srand (seed);

    for (int i = 0; i < count; i++)
        GetPassword();

    return 0;
}
