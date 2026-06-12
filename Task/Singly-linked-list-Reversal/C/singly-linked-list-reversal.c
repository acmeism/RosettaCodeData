 #include <stdlib.h>

 struct node {
     struct node *next;
     int data;
 };

 struct node *
 reverse(struct node *head) {
     struct node *prev, *cur, *next;
     prev = NULL;
     for (cur = head; cur != NULL; cur = next) {
         next = cur->next;
         cur->next = prev;
         prev = cur;
     }
     return prev;
 }

