/*REXX program illustrates first-class environments (using hailstone #s)*/
parse arg #envs .;    env_.=;    if #envs==''  then #envs=12

/*═════════════════════════════════════initialize (twelve) environments.*/
  do init=1  for #envs;    env_.init=init;    end

/*═════════════════════════════════════process environments until done. */
     do forever   until env_.0;        env_.0=1
          do k=1  for #envs
          env_.k=env_.k hailstone(k)   /*where the rubber meets the road*/
          end   /*k*/
     end        /*forever*/

/*═════════════════════════════════════show results in tabular form.    */
count=0;    do lines=-1  until _==''; _=
                    do j=1  for #envs
                          select
                          when count== 1 then _=_ right(words(env_.j)-1,3)
                          when lines==-1 then _=_ right(j,3)
                          when lines== 0 then _=_ right('',3,'─')
                          otherwise       _=_ right(word(env_.j,lines),3)
                          end   /*select*/
                    end         /*j*/

            if count==1  then count=2
            _=strip(_,'T')
            if _==''     then count=count+1
            if count==1  then _=copies(' ═══',#envs)
            if _\==''    then say substr(_,2)
            end   /*lines*/
exit                                   /*stick a fork in it, we're done.*/

/*─────────────────────────────────────HAILSTONE (Collatz) subroutine───*/
hailstone:  procedure expose env_.;  arg n;   _=word(env_.n,words(env_.n))
if _==1 then return ''; env_.0=0; if _//2==0 then return _%2; return _*3+1
