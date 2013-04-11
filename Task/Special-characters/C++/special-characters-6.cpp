#define STR(x) #x
int main()
{
  std::cout << STR(Hello world) << std::endl; // STR(Hello world) expands to "Hello world"
}
