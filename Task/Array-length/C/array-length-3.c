#define _CRT_SECURE_NO_WARNINGS    // turn off panic warnings
#define _CRT_NONSTDC_NO_WARNINGS   // enable old-gold POSIX names in MSVS

#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>


struct StringArray
{
    size_t sizeOfArray;
    size_t numberOfElements;
    char** elements;
};
typedef struct StringArray* StringArray;

StringArray StringArray_new(size_t size)
{
    StringArray this = calloc(1, sizeof(struct StringArray));
    if (this)
    {
        this->elements = calloc(size, sizeof(int));
        if (this->elements)
            this->sizeOfArray = size;
        else
        {
            free(this);
            this = NULL;
        }
    }
    return this;
}

void StringArray_delete(StringArray* ptr_to_this)
{
    assert(ptr_to_this != NULL);
    StringArray this = (*ptr_to_this);
    if (this)
    {
        for (size_t i = 0; i < this->sizeOfArray; i++)
            free(this->elements[i]);
        free(this->elements);
        free(this);
        this = NULL;
    }
}

void StringArray_add(StringArray this, ...)
{
    char* s;
    va_list args;
    va_start(args, this);
    while (this->numberOfElements < this->sizeOfArray && (s = va_arg(args, char*)))
        this->elements[this->numberOfElements++] = strdup(s);
    va_end(args);
}


int main(int argc, char* argv[])
{
    StringArray a = StringArray_new(10);
    StringArray_add(a, "apple", "orange", NULL);

    printf(
        "There are %d elements in an array with a capacity of %d elements:\n\n",
        a->numberOfElements, a->sizeOfArray);

    for (size_t i = 0; i < a->numberOfElements; i++)
        printf("    the element %d is the string \"%s\"\n", i, a->elements[i]);

    StringArray_delete(&a);

    return EXIT_SUCCESS;
}
