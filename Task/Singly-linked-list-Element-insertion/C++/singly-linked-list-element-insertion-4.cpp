while (a)
{
  link<int>* tmp = a;
  a = a->next;
  delete tmp;
}
