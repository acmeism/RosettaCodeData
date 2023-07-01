/*REXX program converts a   URL─encoded string  ──►  its original unencoded form.       */
url.1='http%3A%2F%2Ffoo%20bar%2F'
url.2='mailto%3A%22Ivan%20Aim%22%20%3Civan%2Eaim%40email%2Ecom%3E'
url.3='%6D%61%69%6C%74%6F%3A%22%49%72%6D%61%20%55%73%65%72%22%20%3C%69%72%6D%61%2E%75%73%65%72%40%6D%61%69%6C%2E%63%6F%6D%3E'
URLs =3
            do j=1  for URLs
            say url.j
            say decodeURL(url.j)
            say
            end   /*j*/
exit
/*──────────────────────────────────────────────────────────────────────────────────────*/
decodeURL:  procedure;  parse arg encoded;     decoded= ''

              do  while encoded\==''
              parse var encoded   head  '%'  +1  code  +2  tail
              decoded= decoded || head
              L= length( strip( code, 'T') )
                 select
                 when L==2 & datatype(code, "X")  then       decoded= decoded || x2c(code)
                 when L\==0                       then do;   decoded= decoded'%'
                                                             tail= code || tail
                                                       end
                 otherwise nop
                 end    /*select*/
              encoded= tail
              end   /*while*/

            return decoded
