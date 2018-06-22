/*Abhishek Ghosh, 7th October 2017*/

/*Almost every C program has the below line,
the #include preprocessor directive is used to
instruct the compiler which files to load before compiling the program.

All preprocessor commands begin with #
*/
#include<stdio.h>

/*The #define preprocessor directive is often used to create abbreviations for code segments*/
#define Hi printf("Hi There.");

/*It can be used, or misused, for rather innovative uses*/

#define start int main(){
#define end return 0;}

start

Hi

/*And here's the nice part, want your compiler to talk to you ?
Just use the #warning pragma if you are using a C99 compliant compiler
like GCC*/
#warning "Don't you have anything better to do ?"

#ifdef __unix__
#warning "What are you doing still working on Unix ?"
printf("\nThis is an Unix system.");
#elif _WIN32
#warning "You couldn't afford a 64 bit ?"
printf("\nThis is a 32 bit Windows system.");
#elif _WIN64
#warning "You couldn't afford an Apple ?"
printf("\nThis is a 64 bit Windows system.");
#endif

end

/*Enlightened ?*/
