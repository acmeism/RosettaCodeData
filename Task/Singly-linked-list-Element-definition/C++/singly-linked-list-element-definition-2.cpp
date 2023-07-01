struct link
{
  link* next;
  int data;
  link(int a_data, link* a_next = 0): next(a_next), data(a_data) {}
};
