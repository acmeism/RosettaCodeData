int foo(char buf[],int length){}

int main()
{
char myArray[30];
int j = foo(myArray,sizeof(myArray)); //passes 30 as the length parameter.
}
