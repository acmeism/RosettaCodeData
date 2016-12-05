struct link
{
  struct link *next;
  struct link *prev;
  void  *data;
  size_t type;
};
