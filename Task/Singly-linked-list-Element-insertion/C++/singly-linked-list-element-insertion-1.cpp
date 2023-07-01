template<typename T> void insert_after(link<T>* list_node, link<T>* new_node)
{
  new_node->next = list_node->next;
  list_node->next = new_node;
};
