void insert(link* anchor, link* newlink) {
  newlink->next = anchor->next;
  newlink->prev = anchor;
  (newlink->next)->prev = newlink;
  anchor->next = newlink;
}
