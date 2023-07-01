/*
 * Write Entire File -- RossetaCode -- dirty hackish solution
 */
#define _CRT_SECURE_NO_WARNINGS  // turn off MS Visual Studio restrictions
#include <stdio.h>

int main(void)
{
    return 0 >= fputs("ANY STRING TO WRITE TO A FILE AT ONCE.",
        freopen("sample.txt","wb",stdout));
}
