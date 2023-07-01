struct Node;
typedef struct Node* Node;
struct Node
{
  Node next;
  Node prev;
  void* data;
};
