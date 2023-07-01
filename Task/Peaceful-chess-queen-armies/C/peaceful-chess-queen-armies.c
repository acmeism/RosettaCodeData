#include <math.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>

enum Piece {
    Empty,
    Black,
    White,
};

typedef struct Position_t {
    int x, y;
} Position;

///////////////////////////////////////////////

struct Node_t {
    Position pos;
    struct Node_t *next;
};

void releaseNode(struct Node_t *head) {
    if (head == NULL) return;

    releaseNode(head->next);
    head->next = NULL;

    free(head);
}

typedef struct List_t {
    struct Node_t *head;
    struct Node_t *tail;
    size_t length;
} List;

List makeList() {
    return (List) { NULL, NULL, 0 };
}

void releaseList(List *lst) {
    if (lst == NULL) return;

    releaseNode(lst->head);
    lst->head = NULL;
    lst->tail = NULL;
}

void addNode(List *lst, Position pos) {
    struct Node_t *newNode;

    if (lst == NULL) {
        exit(EXIT_FAILURE);
    }

    newNode = malloc(sizeof(struct Node_t));
    if (newNode == NULL) {
        exit(EXIT_FAILURE);
    }

    newNode->next = NULL;
    newNode->pos = pos;

    if (lst->head == NULL) {
        lst->head = lst->tail = newNode;
    } else {
        lst->tail->next = newNode;
        lst->tail = newNode;
    }

    lst->length++;
}

void removeAt(List *lst, size_t pos) {
    if (lst == NULL) return;

    if (pos == 0) {
        struct Node_t *temp = lst->head;

        if (lst->tail == lst->head) {
            lst->tail = NULL;
        }

        lst->head = lst->head->next;
        temp->next = NULL;

        free(temp);
        lst->length--;
    } else {
        struct Node_t *temp = lst->head;
        struct Node_t *rem;
        size_t i = pos;

        while (i-- > 1) {
            temp = temp->next;
        }

        rem = temp->next;
        if (rem == lst->tail) {
            lst->tail = temp;
        }

        temp->next = rem->next;

        rem->next = NULL;
        free(rem);

        lst->length--;
    }
}

///////////////////////////////////////////////

bool isAttacking(Position queen, Position pos) {
    return queen.x == pos.x
        || queen.y == pos.y
        || abs(queen.x - pos.x) == abs(queen.y - pos.y);
}

bool place(int m, int n, List *pBlackQueens, List *pWhiteQueens) {
    struct Node_t *queenNode;
    bool placingBlack = true;
    int i, j;

    if (pBlackQueens == NULL || pWhiteQueens == NULL) {
        exit(EXIT_FAILURE);
    }

    if (m == 0) return true;
    for (i = 0; i < n; i++) {
        for (j = 0; j < n; j++) {
            Position pos = { i, j };

            queenNode = pBlackQueens->head;
            while (queenNode != NULL) {
                if ((queenNode->pos.x == pos.x && queenNode->pos.y == pos.y) || !placingBlack && isAttacking(queenNode->pos, pos)) {
                    goto inner;
                }
                queenNode = queenNode->next;
            }

            queenNode = pWhiteQueens->head;
            while (queenNode != NULL) {
                if ((queenNode->pos.x == pos.x && queenNode->pos.y == pos.y) || placingBlack && isAttacking(queenNode->pos, pos)) {
                    goto inner;
                }
                queenNode = queenNode->next;
            }

            if (placingBlack) {
                addNode(pBlackQueens, pos);
                placingBlack = false;
            } else {
                addNode(pWhiteQueens, pos);
                if (place(m - 1, n, pBlackQueens, pWhiteQueens)) {
                    return true;
                }
                removeAt(pBlackQueens, pBlackQueens->length - 1);
                removeAt(pWhiteQueens, pWhiteQueens->length - 1);
                placingBlack = true;
            }

        inner: {}
        }
    }
    if (!placingBlack) {
        removeAt(pBlackQueens, pBlackQueens->length - 1);
    }
    return false;
}

void printBoard(int n, List *pBlackQueens, List *pWhiteQueens) {
    size_t length = n * n;
    struct Node_t *queenNode;
    char *board;
    size_t i, j, k;

    if (pBlackQueens == NULL || pWhiteQueens == NULL) {
        exit(EXIT_FAILURE);
    }

    board = calloc(length, sizeof(char));
    if (board == NULL) {
        exit(EXIT_FAILURE);
    }

    queenNode = pBlackQueens->head;
    while (queenNode != NULL) {
        board[queenNode->pos.x * n + queenNode->pos.y] = Black;
        queenNode = queenNode->next;
    }

    queenNode = pWhiteQueens->head;
    while (queenNode != NULL) {
        board[queenNode->pos.x * n + queenNode->pos.y] = White;
        queenNode = queenNode->next;
    }

    for (i = 0; i < length; i++) {
        if (i != 0 && i % n == 0) {
            printf("\n");
        }
        switch (board[i]) {
        case Black:
            printf("B ");
            break;
        case White:
            printf("W ");
            break;
        default:
            j = i / n;
            k = i - j * n;
            if (j % 2 == k % 2) {
                printf("  ");
            } else {
                printf("# ");
            }
            break;
        }
    }

    printf("\n\n");
}

void test(int n, int q) {
    List blackQueens = makeList();
    List whiteQueens = makeList();

    printf("%d black and %d white queens on a %d x %d board:\n", q, q, n, n);
    if (place(q, n, &blackQueens, &whiteQueens)) {
        printBoard(n, &blackQueens, &whiteQueens);
    } else {
        printf("No solution exists.\n\n");
    }

    releaseList(&blackQueens);
    releaseList(&whiteQueens);
}

int main() {
    test(2, 1);

    test(3, 1);
    test(3, 2);

    test(4, 1);
    test(4, 2);
    test(4, 3);

    test(5, 1);
    test(5, 2);
    test(5, 3);
    test(5, 4);
    test(5, 5);

    test(6, 1);
    test(6, 2);
    test(6, 3);
    test(6, 4);
    test(6, 5);
    test(6, 6);

    test(7, 1);
    test(7, 2);
    test(7, 3);
    test(7, 4);
    test(7, 5);
    test(7, 6);
    test(7, 7);

    return EXIT_SUCCESS;
}
