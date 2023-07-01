int main(void)
{
  const char *string = "Hello, world!";
  size_t length = 0;

  const char *p = string;
  while (*p++ != '\0') length++;

  return 0;
}
