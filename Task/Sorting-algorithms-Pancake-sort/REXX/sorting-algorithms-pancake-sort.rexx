/*REXX program sorts/shows an array using the  pancake  sort  algorithm.*/
call gen@                              /*generate elements in the array.*/
call show@  'before sort'              /*show the BEFORE array elements.*/
call pancakeSort    #items             /*invoke the pancake sort. Yummy.*/
call show@  ' after sort'              /*show the  AFTER array elements.*/
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────PANCAKESORT subroutine──────────────*/
pancakeSort: procedure expose @.;   parse arg n

          do n-1                        /*perform this loop  N-1  times.*/
          !=@.1;   ?=1
                                        do j=2  to n
                                        if @.j<=!  then iterate
                                        !=@.j;     ?=j
                                        end   /*j*/
          call flip ?;   call flip n
          n=n-1
          end   /*n-1*/
return
/*──────────────────────────────────FLIP subroutine─────────────────────*/
flip: procedure expose @.;  parse arg w
            do i=1  for (w+1)%2        /*In REXX,  %  is integer divide.*/
            kmip1=w-i+1;   _=@.i;   @.i=@.kmip1;   @.kmip1=_
            end   /*i*/
return
/*──────────────────────────────────GEN@ subroutine─────────────────────*/
gen@: @.=''                            /*assign a   default  value.     */
                   /*Generate some  bread primes which are primes of the*/
                   /*form:   (p-3)÷2  and  2∙p+3   where  p  is a prime.*/
                   /*Bread primes are related to sandwich & meat primes.*/

 @.1=    2   ;              @.17=  113  ;            @.33= -55
 @.2=   17   ;              @.18=  461  ;            @.34= -21
 @.3=    5   ;              @.19=  137  ;            @.35=  -1
 @.4=   29   ;              @.20=  557  ;            @.36=  -8
 @.5=    7   ;              @.21=  167  ;            @.37=  -8
 @.6=   37   ;              @.22=  677  ;            @.38= -21
 @.7=   13   ;              @.23=  173  ;            @.39= -55
 @.8=   61   ;              @.24=  701  ;            @.40=   0
 @.9=   43   ;              @.25=  797  ;            @.41=   0
@.10=  181   ;              @.26= 1117
@.11=   47   ;              @.27=  307        /*The non-positive numbers*/
@.12=  197   ;              @.28= 1237        /*above are some negative */
@.13=   67   ;              @.29= 1597        /*Fibonacci numbers, some */
@.14=  277   ;              @.30=  463        /*of which where specified*/
@.15=   97   ;              @.31= 1861        /*twice just 'cause I felt*/
@.16=  397   ;              @.32=  467        /*like it.    Also, added */
                                              /*two zeroes, just 'cause.*/
  do #items=1 while @.#items\==''; end /*find how many entries in array.*/

#items=#items-1                        /*adjust the  #items  slightly.  */
return
/*──────────────────────────────────SHOW@ subroutine────────────────────*/
show@: widthH=length(#items)           /*the maximum width of any line. */
                             do k=1  for #items
                             say 'element'  right(k,widthH) arg(1)':'  @.k
                             end  /*k*/
say copies('─',79)                     /*show an eyeball separator line.*/
return
