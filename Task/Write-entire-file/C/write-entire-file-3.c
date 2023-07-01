/*
 * Write Entire File -- RossetaCode -- plain POSIX write() from io.h
 */

#define _CRT_SECURE_NO_WARNINGS  // turn off MS Visual Studio restrictions
#define _CRT_NONSTDC_NO_WARNINGS // turn off MS Visual Studio restrictions

#include <assert.h>
#include <fcntl.h>
#include <io.h>

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
    int file; // file handle is an integer (see Fortran ;)

    // Notice: we can not trust in assertions to work.
    // Assertions can be turned off by #define NDEBUG.
    //
    assert( fileName );
    assert( data );
    assert( size >  0 );

    if(fileName && fileName[0] && (file=open(fileName,O_CREAT|O_BINARY|O_WRONLY))!=(-1))
    {
        if ( data )
            numberBytesWritten = write( file, data, size );
        close( file );
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

    // Filling data array with 'Z' character.
    // Of course, you can use any other data here.
    //
    int i;
    for ( i = 0; i < DATA_LENGTH; i++ )
    {
        data[i] = 'Z';
    }

    // Write entire file at once.
    //
    if ( writeEntireFile("sample.txt", data, DATA_LENGTH ) == DATA_LENGTH )
        return 0;
    else
        return 1;
}
