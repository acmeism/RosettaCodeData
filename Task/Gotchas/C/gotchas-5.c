int foo()
{
#define size_of_bar 20  //the sizeof operator is the same as doing this essentially.

char bar[size_of_bar];
return size_of_bar;
}
