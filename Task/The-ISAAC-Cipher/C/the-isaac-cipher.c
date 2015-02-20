/* Known to compile and work with tcc in win32 & gcc on Linux (with warnings)
------------------------------------------------------------------------------
readable.c: My random number generator, ISAAC.
(c) Bob Jenkins, March 1996, Public Domain
You may use this code in any way you wish, and it is free.  No warrantee.
------------------------------------------------------------------------------
*/
#include <stdio.h>
#include <stddef.h>
#include <string.h>
#ifdef _MSC_VER
  typedef unsigned __int32 uint32_t;
#else
  #include <stdint.h>
#endif

/* a ub4 is an unsigned 4-byte quantity */
typedef  uint32_t  ub4;

/* external results */
ub4 randrsl[256], randcnt;

/* internal state */
static    ub4 mm[256];
static    ub4 aa=0, bb=0, cc=0;

void isaac()
{
   register ub4 i,x,y;

   cc = cc + 1;    /* cc just gets incremented once per 256 results */
   bb = bb + cc;   /* then combined with bb */

   for (i=0; i<256; ++i)
   {
     x = mm[i];
     switch (i%4)
     {
     case 0: aa = aa^(aa<<13); break;
     case 1: aa = aa^(aa>>6); break;
     case 2: aa = aa^(aa<<2); break;
     case 3: aa = aa^(aa>>16); break;
     }
     aa              = mm[(i+128)%256] + aa;
     mm[i]      = y  = mm[(x>>2)%256] + aa + bb;
     randrsl[i] = bb = mm[(y>>10)%256] + x;
   }
   // not in original readable.c
   randcnt = 0;
}

/* if (flag!=0), then use the contents of randrsl[] to initialize mm[]. */
#define mix(a,b,c,d,e,f,g,h) \
{ \
   a^=b<<11; d+=a; b+=c; \
   b^=c>>2;  e+=b; c+=d; \
   c^=d<<8;  f+=c; d+=e; \
   d^=e>>16; g+=d; e+=f; \
   e^=f<<10; h+=e; f+=g; \
   f^=g>>4;  a+=f; g+=h; \
   g^=h<<8;  b+=g; h+=a; \
   h^=a>>9;  c+=h; a+=b; \
}

void randinit(int flag)
{
   register int i;
   ub4 a,b,c,d,e,f,g,h;
   aa=bb=cc=0;
   a=b=c=d=e=f=g=h=0x9e3779b9;  /* the golden ratio */

   for (i=0; i<4; ++i)          /* scramble it */
   {
     mix(a,b,c,d,e,f,g,h);
   }

   for (i=0; i<256; i+=8)   /* fill in mm[] with messy stuff */
   {
     if (flag)                  /* use all the information in the seed */
	 {
       a+=randrsl[i  ]; b+=randrsl[i+1]; c+=randrsl[i+2]; d+=randrsl[i+3];
       e+=randrsl[i+4]; f+=randrsl[i+5]; g+=randrsl[i+6]; h+=randrsl[i+7];
     }
     mix(a,b,c,d,e,f,g,h);
     mm[i  ]=a; mm[i+1]=b; mm[i+2]=c; mm[i+3]=d;
     mm[i+4]=e; mm[i+5]=f; mm[i+6]=g; mm[i+7]=h;
   }

   if (flag)
   {        /* do a second pass to make all of the seed affect all of mm */
	 for (i=0; i<256; i+=8)
     {
       a+=mm[i  ]; b+=mm[i+1]; c+=mm[i+2]; d+=mm[i+3];
       e+=mm[i+4]; f+=mm[i+5]; g+=mm[i+6]; h+=mm[i+7];
       mix(a,b,c,d,e,f,g,h);
       mm[i  ]=a; mm[i+1]=b; mm[i+2]=c; mm[i+3]=d;
       mm[i+4]=e; mm[i+5]=f; mm[i+6]=g; mm[i+7]=h;
     }
   }

   isaac();            /* fill in the first set of results */
   randcnt=0;        /* prepare to use the first set of results */
}


// Get a random 32-bit value 0..MAXINT
ub4 iRandom()
{
	ub4 r = randrsl[randcnt];
	++randcnt;
	if (randcnt >255) {
		isaac();
		randcnt = 0;
	}
	return r;
}


// Get a random character in printable ASCII range
char iRandA()
{	
	return iRandom() % 95 + 32;
}


// Seed ISAAC with a string
void iSeed(char *seed, int flag)
{
	register ub4 i,m;
	for (i=0; i<256; i++) mm[i]=0;
	m = strlen(seed);
	for (i=0; i<256; i++)
	{
	// in case seed has less than 256 elements
        if (i>m) randrsl[i]=0;  else randrsl[i] = seed[i];
	}
	// initialize ISAAC with seed
	randinit(flag);
}


// maximum length of message
#define MAXMSG 4096
#define MOD 95
#define START 32
// cipher modes for Caesar
enum ciphermode {
	mEncipher, mDecipher, mNone
};


// XOR cipher on random stream. Output: ASCII string
char v[MAXMSG];
char* Vernam(char *msg)
	{
		register ub4 i,l;
		l = strlen(msg);
		// zeroise v
		memset(v,'\0',l+1);
		// XOR message
		for (i=0; i<l; i++)
			v[i] = iRandA() ^ msg[i];
		return v;
	}

	
// Caesar-shift a printable character
char Caesar(enum ciphermode m, char ch, char shift, char modulo, char start)
	{
		register int n;
		if (m == mDecipher) shift = -shift;
		n = (ch-start) + shift;
		n = n % modulo;
		if (n<0) n += modulo;
		return start+n;
	}
	
// Caesar-shift a string on a pseudo-random stream
char c[MAXMSG];
char* CaesarStr(enum ciphermode m, char *msg, char modulo, char start)
	{
		register ub4 i,l;
		l = strlen(msg);
		// zeroise c
		memset(c,'\0',l+1);
		// Caesar-shift message
		for (i=0; i<l; i++)
			c[i] = Caesar(m, msg[i], iRandA(), modulo, start);
		return c;
	}

	
int main()
{
	register ub4 n,l;
	// input: message and key
	char *msg = "a Top Secret secret";
	char *key = "this is my secret key";
	// Vernam ciphertext & plaintext
	char vctx[MAXMSG], vptx[MAXMSG];
	// Caesar ciphertext & plaintext
	char cctx[MAXMSG], cptx[MAXMSG];
	l = strlen(msg);
	// Encrypt: Vernam XOR
	iSeed(key,1);
	strcpy(vctx, Vernam(msg));
	// Encrypt: Caesar
	strcpy(cctx, CaesarStr(mEncipher, msg, MOD, START));
	// Decrypt: Vernam XOR
	iSeed(key,1);
	strcpy(vptx, Vernam(vctx));
	// Decrypt: Caesar
	strcpy(cptx, CaesarStr(mDecipher,cctx, MOD, START));
	// Program output
	printf("Message: %s\n",msg);
	printf("Key    : %s\n",key);
	printf("XOR    : ");
	// Output Vernam ciphertext as a string of hex digits
	for (n=0; n<l; n++) printf("%02X",vctx[n]);
	printf("\n");
	// Output Vernam decrypted plaintext
	printf("XOR dcr: %s\n",vptx);
	// Caesar
	printf("MOD    : ");
	// Output Caesar ciphertext as a string of hex digits
	for (n=0; n<l; n++) printf("%02X",cctx[n]);
	printf("\n");
	// Output Caesar decrypted plaintext
	printf("MOD dcr: %s\n",cptx);
	return 0;
}
