#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define NUM_ROOMS 20
#define ARROWS 5

typedef enum { false, true } bool;

typedef struct {
    int connected[3];
    bool has_wumpus;
    bool has_bat;
    bool has_pit;
} Room;

Room cave[NUM_ROOMS + 1]; // Cave rooms are numbered from 1 to 20

void initialize_cave() {
    int i, j;
    // Initialize cave rooms
    for (i = 1; i <= NUM_ROOMS; i++) {
        for (j = 0; j < 3; j++) {
            cave[i].connected[j] = (i + j) % NUM_ROOMS + 1; // Circular connections
        }
        cave[i].has_wumpus = false;
        cave[i].has_bat = false;
        cave[i].has_pit = false;
    }
    // Randomly place wumpus, bats, and pits
    cave[rand() % NUM_ROOMS + 1].has_wumpus = true;
    for (i = 0; i < 2; i++) {
        cave[rand() % NUM_ROOMS + 1].has_bat = true;
        cave[rand() % NUM_ROOMS + 1].has_pit = true;
    }
}

void sense(int room) {
    printf("You are in room %d.\n", room);
    int i, adjacent_room;
    for (i = 0; i < 3; i++) {
        adjacent_room = cave[room].connected[i];
        if (cave[adjacent_room].has_wumpus)
            printf("You smell something terrible nearby.\n");
        if (cave[adjacent_room].has_bat)
            printf("You hear a rustling.\n");
        if (cave[adjacent_room].has_pit)
            printf("You feel a cold wind blowing from a nearby cavern.\n");
    }
}

void move(int *room) {
    int choice;
    printf("Choose an adjacent room to move into: ");
    scanf("%d", &choice);
    if (choice < 1 || choice > 3) {
        printf("Invalid choice. Please choose a number between 1 and 3.\n");
        move(room);
        return;
    }
    *room = cave[*room].connected[choice - 1];
}

void shoot(int room, int *arrows, bool *game_over) {
    int choice, adjacent_room;
    printf("Choose an adjacent room to shoot into: ");
    scanf("%d", &choice);
    if (choice < 1 || choice > 3) {
        printf("Invalid choice. Please choose a number between 1 and 3.\n");
        shoot(room, arrows, game_over);
        return;
    }
    adjacent_room = cave[room].connected[choice - 1];
    if (cave[adjacent_room].has_wumpus) {
        printf("Congratulations! You've killed the Wumpus!\n");
        *game_over = true;
        return;
    }
    else {
        if (rand() % 4 != 0) { // 75% chance of waking up the wumpus
            if (cave[adjacent_room].has_wumpus) {
                printf("The Wumpus has woken up and eaten you!\n");
                *game_over = true;
                return;
            }
        }
        printf("You missed! The Wumpus is still asleep.\n");
    }
    (*arrows)--;
}

int main() {
    srand(time(NULL));
    initialize_cave();
    int current_room = 1;
    int arrows = ARROWS;
    bool game_over = false;

    printf("Welcome to Hunt the Wumpus!\n");

    while (!game_over) {
        sense(current_room);
        printf("Choose your action:\n");
        printf("1. Move to an adjacent room\n");
        printf("2. Shoot into an adjacent room\n");

        int choice;
        printf("Enter your choice (1 or 2): ");
        scanf("%d", &choice);

        switch(choice) {
            case 1:
                move(&current_room);
                break;
            case 2:
                if (arrows > 0) {
                    shoot(current_room, &arrows, &game_over);
                } else {
                    printf("You're out of arrows! You lost the game.\n");
                    game_over = true;
                }
                break;
            default:
                printf("Invalid choice. Please choose 1 or 2.\n");
        }
    }

    return 0;
}
