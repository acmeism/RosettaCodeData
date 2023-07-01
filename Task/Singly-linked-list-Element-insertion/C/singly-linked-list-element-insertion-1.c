void insert_append (struct link *anchor, struct link *newlink) {
  newlink->next = anchor->next;
  anchor->next = newlink;
}
