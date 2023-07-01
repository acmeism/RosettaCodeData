int noargs(void); /* Declare a function with no argument that returns an integer */
int twoargs(int a,int b); /* Declare a function with two arguments that returns an integer */
int twoargs(int ,int); /* Parameter names are optional in a prototype definition */
int anyargs(); /* An empty parameter list can be used to declare a function that accepts varargs */
int atleastoneargs(int, ...); /* One mandatory integer argument followed by varargs */
