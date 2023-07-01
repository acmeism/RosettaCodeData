#include <stdio.h>
#include <string.h>
/* note that UID & GID are of type "int" */
typedef const char *STRING;
typedef struct{STRING fullname, office, extension, homephone, email; } gecos_t;
typedef struct{STRING account, password; int uid, gid; gecos_t gecos; STRING directory, shell; } passwd_t;

#define GECOS_FMT "%s,%s,%s,%s,%s"
#define PASSWD_FMT "%s:%s:%d:%d:"GECOS_FMT":%s:%s"

passwd_t passwd_list[]={
  {"jsmith", "x", 1001, 1000, /* UID and GID are type int */
    {"Joe Smith", "Room 1007", "(234)555-8917", "(234)555-0077", "jsmith@rosettacode.org"},
    "/home/jsmith", "/bin/bash"},
  {"jdoe", "x", 1002, 1000,
    {"Jane Doe", "Room 1004", "(234)555-8914", "(234)555-0044", "jdoe@rosettacode.org"},
    "/home/jdoe", "/bin/bash"}
};

main(){
/****************************
* Create a passwd text file *
****************************/
  FILE *passwd_text=fopen("passwd.txt", "w");
  int rec_num;
  for(rec_num=0; rec_num < sizeof passwd_list/sizeof(passwd_t); rec_num++)
    fprintf(passwd_text, PASSWD_FMT"\n", passwd_list[rec_num]);
  fclose(passwd_text);

/********************************
* Load text ready for appending *
********************************/
  passwd_text=fopen("passwd.txt", "a+");
  char passwd_buf[BUFSIZ]; /* warning: fixed length */
  passwd_t new_rec =
      {"xyz", "x", 1003, 1000, /* UID and GID are type int */
          {"X Yz", "Room 1003", "(234)555-8913", "(234)555-0033", "xyz@rosettacode.org"},
          "/home/xyz", "/bin/bash"};
  sprintf(passwd_buf, PASSWD_FMT"\n", new_rec);
/* An atomic append without a file lock,
   Note: wont work on some file systems, eg NFS */
  write(fileno(passwd_text), passwd_buf, strlen(passwd_buf));
  close(passwd_text);

/***********************************************
* Finally reopen and check record was appended *
***********************************************/
  passwd_text=fopen("passwd.txt", "r");
  while(!feof(passwd_text))
    fscanf(passwd_text, "%[^\n]\n", passwd_buf, "\n");
  if(strstr(passwd_buf, "xyz"))
    printf("Appended record: %s\n", passwd_buf);
}
