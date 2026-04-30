#include <stdlib.h>
#include <stdio.h>
typedef struct node{
  char value;
  struct node* next;
} node;
typedef struct charList{
  node* first;
  int size;
} charList;

charList createList(){
  charList foo = {.first = NULL, .size = 0};
  return foo;
}
int addEl(charList* list, char c){
  if(list != NULL){
    node* foo = (node*)malloc(sizeof(node));
    if(foo == NULL) return -1;
    foo->value = c; foo->next = NULL;
    if(list->first == NULL){
      list->first = foo;
    }else{
      node* it= list->first;
      while(it->next != NULL)it = it->next;
      it->next = foo;
    }
    list->size = list->size+1;
    return 0;
  }else return -1;
}
int removeEl(charList* list, int index){
    if(list != NULL && list->size > index){
      node* it = list->first;
      for(int i = 0; i < index-1; i++) it = it->next;
      node* el = it->next;
      it->next = el->next;
      free(el);
      list->size--;
      return 0;
    }else return -1;
}
char getEl(charList* list, int index){
    if(list != NULL && list->size > index){
        node* it = list->first;
        for(int i = 0; i < index; i++) it = it->next;
        return it->value;
    }else return '\0';
}
static void cleanHelp(node* el){
  if(el != NULL){
    if(el->next != NULL) cleanHelp(el->next);
    free(el);
  }
}
void clean(charList* list){
  cleanHelp(list->first);
  list->size = 0;
}
