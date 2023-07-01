/* Programa: Número mayor de tres números introducidos (Solución 1) */

#include <conio.h>
#include <stdio.h>

int main()
{
    int n1, n2, n3;

    printf( "\n   Introduzca el primer n%cmero (entero): ", 163 );
    scanf( "%d", &n1 );
    printf( "\n   Introduzca el segundo n%cmero (entero): ", 163 );
    scanf( "%d", &n2 );
    printf( "\n   Introduzca el tercer n%cmero (entero): ", 163 );
    scanf( "%d", &n3 );

    if ( n1 >= n2 && n1 >= n3 )
        printf( "\n   %d es el mayor.", n1 );
    else

        if ( n2 > n3 )
            printf( "\n   %d es el mayor.", n2 );
        else
            printf( "\n   %d es el mayor.", n3 );

    getch(); /* Pausa */

    return 0;
}
