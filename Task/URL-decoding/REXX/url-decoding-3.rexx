/*REXX pgm convert an URL─encoded string ──► its original unencoded form*/
url.1 = 'http%3A%2F%2Ffoo%20bar%2F'
url.2 = 'mailto%3A%22Ivan%20Aim%22%20%3Civan%2Eaim%40email%2Ecom%3E'
url.3 = '%6D%61%69%6C%74%6F%3A%22%49%72%6D%61%20%55%73%65%72%22%20%3C%69%72%6D%61%2E%75%73%65%72%40%6D%61%69%6C%2E%63%6F%6D%3E'
URLs=3
            do j=1  for URLs;     say
            say           url.j
            say URLdecode(url.j)
            end   /*j*/
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────URLDECODE subroutine────────────────*/
URLdecode:  procedure;  parse arg yyy  /*get encoded URL from arg list. */
yyy=translate(yyy,,'+')                /*special case for encoded blank.*/
URL=''
                do  until yyy=''
                parse var yyy plain '%' +1 code +2 yyy
                URL=URL || plain
                if datatype(code,'X') then URL=URL || x2c(code)
                                      else URL=URL'%'code
                end   /*until*/
return URL
