#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct sCarpet {
    int dim;      // dimension
    char *data;   // character data
    char **rows;  // pointers to data rows
} *Carpet;

/* Clones a tile into larger carpet, or blank if center */
void TileCarpet( Carpet d, int r, int c, Carpet tile )
{
    int y0 = tile->dim*r;
    int x0 = tile->dim*c;
    int k,m;

    if ((r==1) && (c==1)) {
        for(k=0; k < tile->dim; k++) {
           for (m=0; m < tile->dim; m++) {
               d->rows[y0+k][x0+m] = ' ';
           }
        }
    }
    else {
        for(k=0; k < tile->dim; k++) {
           for (m=0; m < tile->dim; m++) {
               d->rows[y0+k][x0+m] = tile->rows[k][m];
           }
        }
    }
}

/* define a 1x1 starting carpet */
static char s1[]= "#";
static char *r1[] = {s1};
static struct sCarpet single = { 1, s1, r1};

Carpet Sierpinski( int n )
{
   Carpet carpet;
   Carpet subCarpet;
   int row,col, rb;
   int spc_rqrd;

   subCarpet = (n > 1) ? Sierpinski(n-1) : &single;

   carpet = malloc(sizeof(struct sCarpet));
   carpet->dim = 3*subCarpet->dim;
   spc_rqrd = (2*subCarpet->dim) * (carpet->dim);
   carpet->data = malloc(spc_rqrd*sizeof(char));
   carpet->rows = malloc( carpet->dim*sizeof(char *));
   for (row=0; row<subCarpet->dim; row++) {
       carpet->rows[row] = carpet->data + row*carpet->dim;
       rb = row+subCarpet->dim;
       carpet->rows[rb] = carpet->data + rb*carpet->dim;
       rb = row+2*subCarpet->dim;
       carpet->rows[rb] = carpet->data + row*carpet->dim;
   }

    for (col=0; col < 3; col++) {
      /* 2 rows of tiles to copy - third group points to same data a first */
      for (row=0; row < 2; row++)
         TileCarpet( carpet, row, col, subCarpet );
    }
    if (subCarpet != &single ) {
       free(subCarpet->rows);
       free(subCarpet->data);
       free(subCarpet);
    }

    return carpet;
}

void CarpetPrint( FILE *fout, Carpet carp)
{
    char obuf[730];
    int row;
    for (row=0; row < carp->dim; row++) {
       strncpy(obuf, carp->rows[row], carp->dim);
       fprintf(fout, "%s\n", obuf);
    }
    fprintf(fout,"\n");
}

int main(int argc, char *argv[])
{
//    FILE *f = fopen("sierp.txt","w");
    CarpetPrint(stdout, Sierpinski(3));
//    fclose(f);
    return 0;
}
