// J Front End Example
// define _WIN32 for Windows, __MACH__ for MAC, J64 for 64-bit
// JE is loaded from current working directory

//make jfex && LD_LIBRARY_PATH=/usr/local/j64-701/bin ./jfex

#ifdef _WIN32
#define _CRT_SECURE_NO_WARNINGS
#include <windows.h>
#include <direct.h>
#define GETPROCADDRESS(h,p) GetProcAddress(h,p)
#define JDLLNAME "\\j.dll"
#else
#define _stdcall
#include <dlfcn.h>
#define GETPROCADDRESS(h,p)	dlsym(h,p)
#ifdef __MACH__
#define JDLLNAME "/libj.dylib"
#else
#define JDLLNAME "/libj.so"
#endif
#define _getcwd getcwd
#endif

#include<stdio.h>
#include<signal.h>
#include<stdlib.h>
#include<string.h>
#include"jfex.h"
#include"jlib.h"

static JDoType jdo;
static JFreeType jfree;
static JgaType jga;
static JGetLocaleType jgetlocale;

static J jt;
static void* hjdll;

static char **adadbreak;
static void sigint(int k){**adadbreak+=1;signal(SIGINT,sigint);}
static char input[1000];

// J calls for input (debug suspension and 1!:1[1) and we call for input
char* _stdcall Jinput(J jt,char* prompt)
{
  fputs(prompt,stdout);
  if(fgets(input, sizeof(input), stdin))
    {
      fputs("\n",stdout);
      **adadbreak+=1;
    }
  return input;
}

static char*buffer = NULL;   /**************************************/
static unsigned length = 0;  /**************************************/
static int Jouts = 0;        /**************************************/

// J calls for output
#define LINEFEED 10          /**************************************/
void _stdcall Joutput(J jt,int type, char* s)  /********************/
{
  size_t L;
  if(MTYOEXIT==type) exit((int)(I)s);
  L = strlen(s);
  L -= (L && (LINEFEED==s[L-1])); /* CRLF not handled. */
  if (L && (!Jouts)) {
    length = L;
    strncpy(buffer,s,L);
    Jouts = 1;
  }
}

int Query(char*Data,unsigned*Length)
{
  void* callbacks[] = {Joutput,NULL,Jinput,0,(void*)SMCON};
  char pathdll[1000];
  _getcwd(pathdll,sizeof(pathdll));
  strcat(pathdll,JDLLNAME);
#ifdef _WIN32
  hjdll=LoadLibraryA(pathdll);
#else
  hjdll=dlopen(pathdll,RTLD_LAZY);
  if (NULL == hjdll)
    hjdll=dlopen(JDLLNAME+1,RTLD_LAZY); /* use LD_LIBRARY_PATH */
#endif
  if(NULL == hjdll)
    {
      fprintf(stderr,"Unix use: $ LD_LIBRARY_PATH=path/to/libj.so %s\n","programName");//*argv);
      fputs("Load library failed: ",stderr);
      fputs(pathdll,stderr);
      fputs("\n",stderr);
      return 0; // load library failed
    }
  jt=((JInitType)GETPROCADDRESS(hjdll,"JInit"))();
  if(!jt) return 0; // JE init failed
  ((JSMType)GETPROCADDRESS(hjdll,"JSM"))(jt,callbacks);
  jdo=(JDoType)GETPROCADDRESS(hjdll,"JDo");
  jfree=(JFreeType)GETPROCADDRESS(hjdll,"JFree");
  jga=(JgaType)GETPROCADDRESS(hjdll,"Jga");
  jgetlocale=(JGetLocaleType)GETPROCADDRESS(hjdll,"JGetLocale");
  adadbreak=(char**)jt; // first address in jt is address of breakdata
  signal(SIGINT,sigint);
  {
    char input[999];
    //memset(input,0,sizeof input);
    buffer = Data;
    sprintf(input,"query %u [ 0!:110<'rc_embed.ijs'\n",*Length); /***deceptive input routine, a hard coded string*********/
    jdo(jt,input);
    if (!Jouts)
      return 0;
    *Length = length;
  }
  jfree(jt);
  return 1;
}
