using System;

namespace cipher {

static class Cipher {

// external results
static uint[] randrsl = new uint[256];
static uint randcnt;
// internal state
static uint[] mm = new uint[256];
static uint aa=0, bb=0, cc=0;


static void isaac() {
   uint i,x,y;
   cc++;    // cc just gets incremented once per 256 results
   bb+=cc;   // then combined with bb

   for (i=0; i<=255; i++) {
     x = mm[i];
     switch (i & 3) {
      case 0: aa = aa ^ (aa << 13); break;
      case 1: aa = aa ^ (aa >> 6); break;
      case 2: aa = aa ^ (aa << 2); break;
      case 3: aa = aa ^ (aa >> 16); break;
     }
     aa = mm[(i+128) & 255] + aa;
     y  = mm[(x >> 2) & 255] + aa + bb;
     mm[i] = y; 	
     bb = mm[(y >> 10) & 255] + x;
     randrsl[i]= bb;
   }
}


// if (flag==TRUE), then use the contents of randrsl[] to initialize mm[].
static void mix(ref uint a, ref uint b, ref uint c, ref uint d, ref uint e, ref uint f, ref uint g, ref uint h) {
   a = a ^ b << 11; d+=a; b+=c;
   b = b ^ c >> 2;  e+=b; c+=d;
   c = c ^ d << 8;  f+=c; d+=e;
   d = d ^ e >> 16; g+=d; e+=f;
   e = e ^ f << 10; h+=e; f+=g;
   f = f ^ g >> 4;  a+=f; g+=h;
   g = g ^ h << 8;  b+=g; h+=a;
   h = h ^ a >> 9;  c+=h; a+=b;
}


static void Init(bool flag) {
  short i; uint a,b,c,d,e,f,g,h;

   aa=0; bb=0; cc=0;
   a=0x9e3779b9; b=a; c=a; d=a;
   e=a; f=a; g=a; h=a;

   for (i=0; i<=3; i++)           // scramble it
        mix(ref a,ref b,ref c,ref d,ref e,ref f,ref g,ref h);

   i=0;
   do  { // fill in mm[] with messy stuff
          if (flag) {     // use all the information in the seed
            a+=randrsl[i  ]; b+=randrsl[i+1]; c+=randrsl[i+2]; d+=randrsl[i+3];
            e+=randrsl[i+4]; f+=randrsl[i+5]; g+=randrsl[i+6]; h+=randrsl[i+7];
          } // if flag

      mix(ref a,ref b,ref c,ref d,ref e,ref f,ref g,ref h);
      mm[i  ]=a; mm[i+1]=b; mm[i+2]=c; mm[i+3]=d;
      mm[i+4]=e; mm[i+5]=f; mm[i+6]=g; mm[i+7]=h;
      i+=8;
      }
   while (i<255);

   if (flag) {
   // do a second pass to make all of the seed affect all of mm
     i=0;
     do {
      a+=mm[i  ]; b+=mm[i+1]; c+=mm[i+2]; d+=mm[i+3];
      e+=mm[i+4]; f+=mm[i+5]; g+=mm[i+6]; h+=mm[i+7];
      mix(ref a,ref b,ref c,ref d,ref e,ref f,ref g,ref h);
      mm[i  ]=a; mm[i+1]=b; mm[i+2]=c; mm[i+3]=d;
      mm[i+4]=e; mm[i+5]=f; mm[i+6]=g; mm[i+7]=h;
      i+=8;
        }
     while (i<255);
   }
   isaac();           // fill in the first set of results
   randcnt=0;       // prepare to use the first set of results
}


// Seed ISAAC with a string
static void Seed(string seed, bool flag) {
	for (int i=0; i<256; i++) mm[i]=0;
	for (int i=0; i<256; i++) randrsl[i]=0;
	int m = seed.Length;
	for (int i=0; i<m; i++) {
        randrsl[i] = seed[i];
	}
	// initialize ISAAC with seed
	Init(flag);
}


// Get a random 32-bit value
static uint Random() {
    uint result = randrsl[randcnt];
    randcnt++;
    if (randcnt>255) {
         isaac(); randcnt=0;
    }
    return result;
}


// Get a random character in printable ASCII range
static byte RandA() {	
	return (byte)(Random() % 95 + 32);
}


// XOR encrypt on random stream. Output: ASCII byte array
static byte[] Vernam(string msg)
	{
		int n,l;
		byte[] v = new byte[msg.Length];
		l = msg.Length;
		// XOR message
		for (n=0; n<l; n++) {
			v[n] = (byte) (RandA() ^ (byte)msg[n]);
		}	
		return v;
	}

	
	public static void Main() {
		string msg = "a Top Secret secret";
		string key = "this is my secret key";
		byte[] xctx= new byte[msg.Length];
		byte[] xptx= new byte[msg.Length];
		string xtcx= "*******************";
		string xtpx= "*******************";
		Seed(key,true);
		// XOR encrypt
		xctx = Vernam(msg);
		xtcx = System.Text.Encoding.ASCII.GetString(xctx);
		// XOR decrypt
		Seed(key,true);
		xptx = Vernam(xtcx);
		xtpx = System.Text.Encoding.ASCII.GetString(xptx);
		Console.WriteLine("Message: "+msg);
		Console.WriteLine("Key    : "+key);
		Console.Write    ("XOR    : ");
		// output ciphertext as a string of hexadecimal digits
		for (int n=0; n<xctx.Length; n++) Console.Write("{0:X2}", xctx[n]);
		Console.WriteLine("\nXOR dcr: "+xtpx);
	}
}
}
