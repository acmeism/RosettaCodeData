/*REXX program  finds  the  common directory path  for a list of files.       */
/* original code: Gerard Schildberger                                         */
/* 20230606 Walter Pachl refurbisher adn improved (file.4 = 'home' -> /)      */
file.  = ''                            /*the default for all file lists (null)*/
file.1 = '/home/user1/tmp/coverage/test'
        /*123456789.123456789.123456768*/
file.2 = '/home/user1/tmp/covert/operator'
file.3 = '/home/user1/tmp/coven/members'

L=length(file.1)                       /*use the length of the first string.  */
Do j=2 While file.j\==''               /*loop for the other file names        */
  diffp=compare(file.j,file.1)         /*find the first different character   */
  If diffp>0 Then Do                   /*Strings are different                */
    L=min(L,diffp)                     /*get the minimum length equal strings.*/
    If right(file.j,1)<>'/' Then Do    /*not a directory                      */
     L=lastpos('/',left(file.j,L))     /* go back to directory end            */
      If L=0 Then Do
        Say 'common directory path: /'
        Exit
        End
      End
    End
  End
common=left(file.1,lastpos('/',file.1,L)) /*determine the shortest DIR string.*/
If right(common,1)=='/' Then           /* remove the trailing /               */
  common=left(common,length(common)-1)
If common=='' then common= "/"         /*if no common directory, assume home. */
Say 'common directory path: 'common
                                       /*stick a fork in it,  we're all done. */
