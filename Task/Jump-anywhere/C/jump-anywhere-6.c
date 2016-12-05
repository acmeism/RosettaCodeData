  char *str;
  int *array;
  FILE *fp;

   str = (char *) malloc(100);
   if(str == NULL)
    goto:  exit;

   fp=fopen("c:\\test.csv", "r");
   if(fp== NULL)
      goto:  clean_up_str;

   array = (int *) malloc(15);
   if(array==NULL)
     goto: clean_up_file;
   ...// read in the csv file and convert to integers

   clean_up_array:
     free(array);
   clean_up_file:
     fclose(fp);
   clean_up_str"
     free(str );
   exit:
   return;
