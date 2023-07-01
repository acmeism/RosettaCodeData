/*
 * Write Entire File -- RossetaCode -- ASCII version with BUFFERED files
 */

#define _CRT_SECURE_NO_WARNINGS

#include <assert.h>
#include <stdio.h>
#include <stdlib.h>

/**
 *  Write entire file at once.
 *
 *  @param fileName file name
 *  @param data     buffer with data
 *  @param size     number of bytes to write
 *
 *  @return Number of bytes have been written.
 */
int writeEntireFile(char* fileName, const void* data, size_t size)
{
    size_t numberBytesWritten = 0; // will be updated

    // Notice: assertions can be turned off by #define NDEBUG
    //
    assert( fileName != NULL );
    assert( data != NULL );
    assert( size >  0 );

    // Check for a null pointer or an empty file name.
    //
    // BTW, should we write  if ( ptr != NULL)  or simply  if ( ptr )  ?
    // Both of these forms are correct. At issue is which is more readable.
    //
    if ( fileName != NULL && *fileName != '\0' )
    {
        // Try to open file in BINARY MODE
        //
        FILE* file = fopen(fileName,"wb");

        // There is a possibility to allocate a big buffer to speed up i/o ops:
        //
        // const size_t BIG_BUFFER_SIZE = 0x20000; // 128KiB
        // void* bigBuffer = malloc(BIG_BUFFER_SIZE);
        // if ( bigBuffer != NULL )
        // {
        //     setvbuf(file,bigBuffer,_IOFBF,BIG_BUFFER_SIZE);
        // }
        //
        // Of course, you should release the malloc allocated buffer somewhere.
        // Otherwise, bigBuffer will be released after the end of the program.


        if ( file != NULL )
        {
            // Return value from fwrite( data, 1, size, file ) is the number
            // of bytes written. Return value from fwrite( data, size, 1, file )
            // is the number of blocks (either 0 or 1) written.
            //
            // Notice, that write (see io.h) is less capable than fwrite.
            //

            if ( data != NULL )
            {
                numberBytesWritten = fwrite( data, 1, size, file );
            }
            fclose( file );
        }
    }
    return numberBytesWritten;
}

#define DATA_LENGTH 8192 /* 8KiB */

int main(void)
{
    // Large arrays can exhaust memory on the stack. This is why the static
    // keyword is used.Static variables are allocated outside the stack.
    //
    static char data[DATA_LENGTH];

    // Filling data array with 'A' character.
    // Of course, you can use any other data here.
    //
    int i;
    for ( i = 0; i < DATA_LENGTH; i++ )
    {
        data[i] = 'A';
    }

    // Write entire file at once.
    //
    if ( writeEntireFile("sample.txt", data, DATA_LENGTH ) == DATA_LENGTH )
        return EXIT_SUCCESS;
    else
        return EXIT_FAILURE;
}
