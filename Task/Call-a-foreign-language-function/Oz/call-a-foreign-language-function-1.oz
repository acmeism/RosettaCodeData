#include "mozart.h"
#include <string.h>

OZ_BI_define(c_strdup,1,1)
{
  OZ_declareVirtualString(0, s1);
  char* s2 = strdup(s1);
  OZ_Term s3 = OZ_string(s2);
  free( s2 );
  OZ_RETURN( s3 );
}
OZ_BI_end

OZ_C_proc_interface * oz_init_module(void)
{
  static OZ_C_proc_interface table[] = {
    {"strdup",1,1,c_strdup},
    {0,0,0,0}
  };
  return table;
}
