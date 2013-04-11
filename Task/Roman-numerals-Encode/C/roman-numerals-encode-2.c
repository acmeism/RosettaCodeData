char *ToRoman(int num, char *buf, int buflen)
{
   static const char romanDgts[] = "ivxlcdmVXLCDM_";
   char *roman = buf + buflen;
   int  rdix, r, v;
   *--roman = '\0';        /* null terminate return string */
   if (num >= 4000000) {
      printf("Number Too Big.\n");
      return NULL;
      }
   for (rdix = 0; rdix < strlen(romanDgts); rdix += 2) {
      if (num == 0) break;
      v = (num % 10) / 5;
      r = num % 5;
      num = num / 10;
      if (r == 4) {
         if (roman < buf+2) {
            printf("Buffer too small.");
            return NULL;
            }
         *--roman = romanDgts[rdix+1+v];
         *--roman = romanDgts[rdix];
         }
      else {
         if (roman < buf+r+v) {
            printf("Buffer too small.");
            return NULL;
            }
         while(r-- > 0) {
            *--roman = romanDgts[rdix];
            }
         if (v==1) {
            *--roman = romanDgts[rdix+1];
            }
         }
      }
   return roman;
}
