makefile(
   lib : [
	  'strdup.o' 'strdup.so'
	 ]
   rules:o('strdup.so':ld('strdup.o'))
   )
