UINT_64 TGost::SWAP32(UINT_32 N1, UINT_32 N2)
{
    UINT_64 N;
	N = N1;
	N = (N<<32)|N2;
	return UINT_64(N);
}

UINT_32 TGost::ReplaceBlock(UINT_32 x)
{
    register i;
    UINT_32 res = 0UL;
    for(i=7;i>=0;i--)
    {
       ui4_0 = x>>(i*4);
       ui4_0 = BS[ui4_0][i];
       res = (res<<4)|ui4_0;
    }
    return res;
}

UINT_64 TGost::MainStep(UINT_64 N,UINT_32 X)
{
   UINT_32 N1,N2,S=0UL;
   N1=UINT_32(N);
   N2=N>>32;
   S = N1 + X % 0x4000000000000;
   S = ReplaceBlock(S);
   S = (S<<11)|(S>>21);
   S ^= N2;
   N2 = N1;
   N1 = S;
   return SWAP32(N2,N1);
}
