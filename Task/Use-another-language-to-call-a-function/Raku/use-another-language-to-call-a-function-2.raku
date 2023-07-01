#include<stdio.h>
#include<stddef.h>
#include<string.h>

int Query(char *Data, size_t *Length) {
   FILE *fp;
   char buf[64];

   sprintf(buf, "/home/user/query.raku --len=%zu", *Length);
   if (!(fp = popen(buf, "r")))
      return 0;
   fgets(Data, *Length, fp);
   *Length = strlen(Data);
   return pclose(fp) >= 0 && *Length != 0;
}
