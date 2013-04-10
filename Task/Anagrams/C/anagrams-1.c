#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <time.h>

char *sortedWord(const char *word, char *wbuf)
{
    char *p1, *p2, *endwrd;
    char t;
    int swaps;

    strcpy(wbuf, word);
    endwrd = wbuf+strlen(wbuf);
    do {
       swaps = 0;
       p1 = wbuf; p2 = endwrd-1;
       while (p1<p2) {
          if (*p2 > *p1) {
             t = *p2; *p2 = *p1; *p1 = t;
             swaps = 1;
          }
          p1++; p2--;
       }
       p1 = wbuf; p2 = p1+1;
       while(p2 < endwrd) {
           if (*p2 > *p1) {
             t = *p2; *p2 = *p1; *p1 = t;
             swaps = 1;
           }
           p1++; p2++;
       }
    } while (swaps);
    return wbuf;
}

static
short cxmap[] = {
    0x06, 0x1f, 0x4d, 0x0c, 0x5c, 0x28, 0x5d, 0x0e, 0x09, 0x33, 0x31, 0x56,
    0x52, 0x19, 0x29, 0x53, 0x32, 0x48, 0x35, 0x55, 0x5e, 0x14, 0x27, 0x24,
    0x02, 0x3e, 0x18, 0x4a, 0x3f, 0x4c, 0x45, 0x30, 0x08, 0x2c, 0x1a, 0x03,
    0x0b, 0x0d, 0x4f, 0x07, 0x20, 0x1d, 0x51, 0x3b, 0x11, 0x58, 0x00, 0x49,
    0x15, 0x2d, 0x41, 0x17, 0x5f, 0x39, 0x16, 0x42, 0x37, 0x22, 0x1c, 0x0f,
    0x43, 0x5b, 0x46, 0x4b, 0x0a, 0x26, 0x2e, 0x40, 0x12, 0x21, 0x3c, 0x36,
    0x38, 0x1e, 0x01, 0x1b, 0x05, 0x4e, 0x44, 0x3d, 0x04, 0x10, 0x5a, 0x2a,
    0x23, 0x34, 0x25, 0x2f, 0x2b, 0x50, 0x3a, 0x54, 0x47, 0x59, 0x13, 0x57,
   };
#define CXMAP_SIZE (sizeof(cxmap)/sizeof(short))


int Str_Hash( const char *key, int ix_max )
{
   const char *cp;
   short mash;
   int  hash = 33501551;
   for (cp = key; *cp; cp++) {
      mash = cxmap[*cp % CXMAP_SIZE];
      hash = (hash >>4) ^ 0x5C5CF5C ^ ((hash<<1) + (mash<<5));
      hash &= 0x3FFFFFFF;
      }
   return  hash % ix_max;
}

typedef struct sDictWord  *DictWord;
struct sDictWord {
    const char *word;
    DictWord next;
};

typedef struct sHashEntry *HashEntry;
struct sHashEntry {
    const char *key;
    HashEntry next;
    DictWord  words;
    HashEntry link;
    short wordCount;
};

#define HT_SIZE 8192

HashEntry hashTable[HT_SIZE];

HashEntry mostPerms = NULL;

int buildAnagrams( FILE *fin )
{
    char buffer[40];
    char bufr2[40];
    char *hkey;
    int hix;
    HashEntry he, *hep;
    DictWord  we;
    int  maxPC = 2;
    int numWords = 0;

    while ( fgets(buffer, 40, fin)) {
        for(hkey = buffer; *hkey && (*hkey!='\n'); hkey++);
        *hkey = 0;
        hkey = sortedWord(buffer, bufr2);
        hix = Str_Hash(hkey, HT_SIZE);
        he = hashTable[hix]; hep = &hashTable[hix];
        while( he && strcmp(he->key , hkey) ) {
            hep = &he->next;
            he = he->next;
        }
        if ( ! he ) {
            he = malloc(sizeof(struct sHashEntry));
            he->next = NULL;
            he->key = strdup(hkey);
            he->wordCount = 0;
            he->words = NULL;
            he->link = NULL;
            *hep = he;
        }
        we = malloc(sizeof(struct sDictWord));
        we->word = strdup(buffer);
        we->next = he->words;
        he->words = we;
        he->wordCount++;
        if ( maxPC < he->wordCount) {
            maxPC = he->wordCount;
            mostPerms = he;
            he->link = NULL;
        }
        else if (maxPC == he->wordCount) {
            he->link = mostPerms;
            mostPerms = he;
        }

        numWords++;
    }
    printf("%d words in dictionary max ana=%d\n", numWords, maxPC);
    return maxPC;
}


int main( )
{
    HashEntry he;
    DictWord  we;
    FILE *f1;

    f1 = fopen("unixdict.txt","r");
    buildAnagrams(f1);
    fclose(f1);

    f1 = fopen("anaout.txt","w");
//    f1 = stdout;

    for (he = mostPerms; he; he = he->link) {
        fprintf(f1,"%d:", he->wordCount);
        for(we = he->words; we; we = we->next) {
            fprintf(f1,"%s, ", we->word);
        }
        fprintf(f1, "\n");
    }

    fclose(f1);
    return 0;
}
