  char *str;
  int *array;
  FILE *fp;

   str = (char *) malloc(100);
   if(str == NULL) {
     return;
   }


   fp=fopen("c:\\test.csv", "r");
   if(fp== NULL) {
     free(str );
     return;
   }

   array = (int *) malloc(15);
   if(array==NULL)   if(fp== NULL) {
     free(str );
     fclose(fp);
     return;
   }

   ...// read in the csv file and convert to integers
