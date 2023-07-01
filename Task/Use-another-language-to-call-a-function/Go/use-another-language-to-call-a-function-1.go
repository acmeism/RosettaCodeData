#include <stdio.h>
#include "_cgo_export.h"

void Run()
{
   char     Buffer [1024];
   size_t   Size = sizeof (Buffer);

   if (0 == Query (Buffer, &Size))
   ...
