int noargs(); // Declare a function with no arguments that returns an integer
int twoargs(int a,int b); // Declare a function with two arguments that returns an integer
int twoargs(int ,int); // Parameter names are optional in a prototype definition
int anyargs(...); // An ellipsis is used to declare a function that accepts varargs
int atleastoneargs(int, ...); // One mandatory integer argument followed by varargs
template<typename T> T declval(T); //A function template
template<typename ...T> tuple<T...> make_tuple(T...); //Function template using parameter pack (since c++11)
