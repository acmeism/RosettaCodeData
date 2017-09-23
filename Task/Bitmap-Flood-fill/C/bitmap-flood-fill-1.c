/*
 * RosettaCode: Bitmap/Flood fill, language C, dialects C89, C99, C11.
 *
 * This is an implementation of the recursive algorithm. For the sake of
 * simplicity, instead of reading files as JPEG, PNG, etc., the program
 * read and write Portable Bit Map (PBM) files in plain text format.
 * Portable Bit Map files can also be read and written with GNU GIMP.
 *
 * The program is just an example, so the image size is limited to 2048x2048,
 * the image can only be black and white, there is no run-time validation.
 *
 * Data is read from a standard input stream, the results are written to the
 * standard output file.
 *
 * In order for this program to work properly it is necessary to allocate
 * enough memory for the program stack. For example, in Microsoft Visual Studio,
 * the option /stack:134217728 declares a 128MB stack instead of the default
 * size of 1MB.
 */
#define _CRT_SECURE_NO_WARNINGS /* Unlock printf etc. in MSVC */
#include <stdio.h>
#include <stdlib.h>

#define MAXSIZE 2048
#define BYTE unsigned char

static int width, height;
static BYTE bitmap[MAXSIZE][MAXSIZE];
static BYTE oldColor;
static BYTE newColor;

void floodFill(int i, int j)
{
    if ( 0 <= i && i < height
    &&   0 <= j && j < width
    &&   bitmap[i][j] == oldColor )
    {
        bitmap[i][j] = newColor;
        floodFill(i-1,j);
        floodFill(i+1,j);
        floodFill(i,j-1);
        floodFill(i,j+1);
    }
}

/* *****************************************************************************
 * Input/output routines.
 */

void skipLine(FILE* file)
{
    while(!ferror(file) && !feof(file) && fgetc(file) != '\n')
        ;
}

void skipCommentLines(FILE* file)
{
    int c;
    int comment = '#';

    while ((c = fgetc(file)) == comment)
        skipLine(file);
    ungetc(c,file);
}

readPortableBitMap(FILE* file)
{
    int i,j;

    skipLine(file);
    skipCommentLines(file);  fscanf(file,"%d",&width);
    skipCommentLines(file);  fscanf(file,"%d",&height);
    skipCommentLines(file);

    if ( width <= MAXSIZE && height <= MAXSIZE )
        for ( i = 0; i < height; i++ )
            for ( j = 0; j < width; j++ )
                fscanf(file,"%1d",&(bitmap[i][j]));
    else exit(EXIT_FAILURE);
}

void writePortableBitMap(FILE* file)
{
    int i,j;
    fprintf(file,"P1\n");
    fprintf(file,"%d %d\n", width, height);
    for ( i = 0; i < height; i++ )
    {
        for ( j = 0; j < width; j++ )
            fprintf(file,"%1d", bitmap[i][j]);
        fprintf(file,"\n");
    }
}

/* *****************************************************************************
 * The main entry point.
 */

int main(void)
{
    oldColor = 1;
    newColor = oldColor ? 0 : 1;
    readPortableBitMap(stdin);
    floodFill(height/2,width/2);
    writePortableBitMap(stdout);
    return EXIT_SUCCESS;
}
