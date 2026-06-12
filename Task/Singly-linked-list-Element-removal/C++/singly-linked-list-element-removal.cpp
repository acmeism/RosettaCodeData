#include <iostream>

// define a singly linked list
struct link
{
  link* next;
  int data;

  link(int newItem, link* head)
  : next{head}, data{newItem}{}
};

void PrintList(link* head)
{
    if(!head) return;
    std::cout << head->data << " ";
    PrintList(head->next);
}

link* RemoveItem(int valueToRemove, link*&head)
{
    // walk the list to look for the node conaining the value including
    // the head node itself
    for(link** node = &head; *node; node = &((*node)->next))
    {
        if((*node)->data == valueToRemove)
        {
            // the item was found; remove it and return its node
            link* removedNode = *node;
            *node = removedNode->next;
            removedNode->next = nullptr;
            return removedNode;
        }
    }

    // the node was not found in the list
    return nullptr;
}

int main()
{
    // link some nodes into a list
    link link33{33, nullptr};
    link link42{42, &link33};
    link link99{99, &link42};
    link link55{55, &link99};
    link* head = &link55;

    std::cout << "Full list: ";
    PrintList(head);

    std::cout << "\nRemove 55: ";
    auto removed = RemoveItem(55, head);
    PrintList(head);
    std::cout << "\nThe removed item: ";
    PrintList(removed);

    std::cout << "\nTry to remove -3: ";
    auto removed2 = RemoveItem(-3, head);
    PrintList(head);
    if (!removed2) std::cout << "\nItem not found\n";
}
