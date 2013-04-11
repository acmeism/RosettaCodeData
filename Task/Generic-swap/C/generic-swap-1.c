void swap(void *va, void *vb, size_t s)
{
  char t, *a = (char*)va, *b = (char*)vb;
  while(--s)
    t = a[s], a[s] = b[s], b[s] = t;
}
