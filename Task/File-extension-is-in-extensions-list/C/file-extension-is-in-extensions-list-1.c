/*
 * File extension is in extensions list (dots allowed).
 *
 * This problem is trivial because the so-called extension is simply the end
 * part of the name.
 */

#define _CRT_SECURE_NO_WARNINGS

#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <locale.h>
#include <string.h>

#ifdef _Bool
#include <stdbool.h>
#else
#define bool int
#define true  1
#define false 0
#endif

/*
 * The implemented algorithm is not the most efficient one: for N extensions
 * of length M it has the cost O(N * M).
 */
int checkFileExtension(char* fileName, char* fileExtensions)
{
    char* fileExtension = fileExtensions;

    if ( *fileName )
    {
        while ( *fileExtension )
        {
            int fileNameLength = strlen(fileName);
            int extensionLength = strlen(fileExtension);
            if ( fileNameLength >= extensionLength )
            {
                char* a = fileName + fileNameLength - extensionLength;
                char* b = fileExtension;
                while ( *a && toupper(*a++) == toupper(*b++) )
                    ;
                if ( !*a )
                    return true;
            }
            fileExtension += extensionLength + 1;
        }
    }
    return false;
}

void printExtensions(char* extensions)
{
    while( *extensions )
    {
        printf("%s\n", extensions);
        extensions += strlen(extensions) + 1;
    }
}

bool test(char* fileName, char* extension, bool expectedResult)
{
    bool result = checkFileExtension(fileName,extension);
    bool returnValue = result == expectedResult;
    printf("%20s  result: %-5s  expected: %-5s  test %s\n",
        fileName,
        result         ? "true"   : "false",
        expectedResult ? "true"   : "false",
        returnValue    ? "passed" : "failed" );
    return returnValue;
}

int main(void)
{
    static char extensions[] = ".zip\0.rar\0.7z\0.gz\0.archive\0.A##\0.tar.bz2\0";

    setlocale(LC_ALL,"");

    printExtensions(extensions);
    printf("\n");

    if ( test("MyData.a##",         extensions,true )
    &&   test("MyData.tar.Gz",      extensions,true )
    &&   test("MyData.gzip",        extensions,false)
    &&   test("MyData.7z.backup",   extensions,false)
    &&   test("MyData...",          extensions,false)
    &&   test("MyData",             extensions,false)
    &&   test("MyData_v1.0.tar.bz2",extensions,true )
    &&   test("MyData_v1.0.bz2",    extensions,false)
    &&   test("filename",           extensions,false)
    )
        printf("\n%s\n", "All tests passed.");
    else
        printf("\n%s\n", "Last test failed.");

    printf("\n%s\n", "press enter");
    getchar();
    return 0;
}
