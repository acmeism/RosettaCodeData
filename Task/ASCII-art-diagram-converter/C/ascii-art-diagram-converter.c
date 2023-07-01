#include <stdlib.h>
#include <stdio.h>
#include <string.h>
enum { MAX_ROWS=14, MAX_NAMES=20, NAME_SZ=80 };

char *Lines[MAX_ROWS] = {
   "  +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+",
   "  |                      ID                       |",
   "  +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+",
   "  |QR|   Opcode  |AA|TC|RD|RA|   Z    |   RCODE   |",
   "  +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+",
   "  |                    QDCOUNT                    |",
   "  +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+",
   "  |                    ANCOUNT                    |",
   "  +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+",
   "  |                    NSCOUNT                    |",
   "  +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+",
   "  |                    ARCOUNT                    |",
   "  +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+"
};
typedef struct {
   unsigned bit3s;
   unsigned mask;
   unsigned data;
   char A[NAME_SZ+2];
}NAME_T;
NAME_T names[MAX_NAMES];
unsigned idx_name;
enum{ID,BITS,QDCOUNT,ANCOUNT,NSCOUNT,ARCOUNT,MAX_HDR};
unsigned header[MAX_HDR]; // for test
unsigned idx_hdr;

int  bit_hdr(char *pLine);
int  bit_names(char *pLine);
void dump_names(void);
void make_test_hdr(void);

int main(void){
   char *p1;   int rv;
   printf("Extract meta-data from bit-encoded text form\n");
   make_test_hdr();
   idx_name = 0;
   for( int i=0; i<MAX_ROWS;i++ ){
      p1 = Lines[i];
      if( p1==NULL ) break;
      if( rv = bit_hdr(Lines[i]), rv>0) continue;
      if( rv = bit_names(Lines[i]),rv>0) continue;
      //printf("%s, %d\n",p1, numbits );
   }
   dump_names();
}

int  bit_hdr(char *pLine){ // count the '+--'
   char *p1 = strchr(pLine,'+');
   if( p1==NULL ) return 0;
   int numbits=0;
   for( int i=0; i<strlen(p1)-1; i+=3 ){
      if( p1[i] != '+' || p1[i+1] != '-' || p1[i+2] != '-' ) return 0;
      numbits++;
   }
   return numbits;
}

int  bit_names(char *pLine){ // count the bit-group names
   char *p1,*p2 = pLine, tmp[80];
   unsigned sz=0, maskbitcount = 15;
   while(1){
      p1 = strchr(p2,'|');  if( p1==NULL ) break;
      p1++;
      p2 = strchr(p1,'|');  if( p2==NULL ) break;
      sz = p2-p1;
      tmp[sz] = 0;  // set end of string
      int k=0;
      for(int j=0; j<sz;j++){  // strip spaces
	 if( p1[j] > ' ') tmp[k++] = p1[j];
      }
      tmp[k]= 0; sz++;
      NAME_T *pn = &names[idx_name++];
      strcpy(&pn->A[0], &tmp[0]);
      pn->bit3s = sz/3;
      if( pn->bit3s < 16 ){
	 for( int i=0; i<pn->bit3s; i++){
	    pn->mask |= 1 << maskbitcount--;
	 }
	 pn->data = header[idx_hdr] & pn->mask;
	 unsigned m2 = pn->mask;
	 while( (m2 & 1)==0 ){
	    m2>>=1;
	    pn->data >>= 1;
	 }
	 if( pn->mask == 0xf ) idx_hdr++;

      }
      else{
	 pn->data = header[idx_hdr++];
      }
   }
   return sz;
}

void dump_names(void){ // print extracted names and bits
   NAME_T *pn;
   printf("-name-bits-mask-data-\n");
   for( int i=0; i<MAX_NAMES; i++ ){
      pn = &names[i];
      if( pn->bit3s < 1 ) break;
      printf("%10s %2d X%04x = %u\n",pn->A, pn->bit3s, pn->mask, pn->data);
   }
   puts("bye..");
}

void make_test_hdr(void){
   header[ID] = 1024;
   header[QDCOUNT] = 12;
   header[ANCOUNT] = 34;
   header[NSCOUNT] = 56;
   header[ARCOUNT] = 78;
   // QR OP   AA TC RD RA Z   RCODE
   // 1  0110 1  0  1  0  000 1010
   // 1011 0101 0000 1010
   // B    5    0    A
   header[BITS] = 0xB50A;
}
