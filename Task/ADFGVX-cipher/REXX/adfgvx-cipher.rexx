/* REXX */
cls
eol=x2c(0D0A) ; msg="ATTACKAT1200AM"
keyword= upper('lifeguard') ; cyph= 'ADFGVX'

   s_sort= keyword ; new_key= ''
   do while length(s_sort) > 0
      nmax= 0
      do i=1 to length(s_sort)
         ch= substr(s_sort,i,1)
         num= c2d(ch)
         if num > nmax then do
            nmax= num
            max_i = i
            end
      end
      s_sort= delstr(s_sort,max_i,1)
      new_key= d2c(nmax)||new_key
   end        /* Alphabetical sorting */

   j=0 ; num_str= '' ; rnd_s= ''
   do while j < 36
      num= random(0,35)
      if wordpos(num,num_str) = 0 then do
         j= j + 1
 	     num_str= num_str||num||' '
		 if num >= 10 then do
		    num= num - 10 + x2d(41)
            num= d2c(num)
		    end
		 rnd_s= rnd_s||num
      end
   end	  /* say 'Generated string: '||rnd_s||eol */

say 'Polybius square:'||eol
call tab cyph, rnd_s ,1
say "Only characters from the '"|| msg||"'"||eol
t= translate(rnd_s,' ',msg)
_t= translate(rnd_s,' ',t)
call tab cyph, _t ,1

   len_c= length(cyph) ; cyph_T=''
   do i=1 to len_c
      ch_i= substr(cyph,i,1)
      do j=1 to len_c
         ch_j= substr(cyph,j,1)
         cyph_T= cyph_T||ch_i||ch_j||' '
      end
   end

   enc_msg= ''
   do i=1 to length(msg)
      ch= substr(msg,i,1)
       j= pos(ch,rnd_s,1)
      enc_msg= enc_msg||word(cyph_T,j)
   end

say "Conversion by table: "||eol||eol||msg||" ==> "||enc_msg||eol
call tab keyword, enc_msg

   len= length(keyword)
   n_row= 0 ; column.= ''
    do while enc_msg <> ''
       parse var enc_msg 1 s1 +(len) enc_msg
       n_row= n_row+1
       do m= 1 to len
          ch_m= substr(s1,m,1)
          column.m= column.m||ch_m
          end
    end

   s_lst= ''
   do m= 1 to len
      ch= substr(new_key,m,1)
       i= pos(ch,keyword,1)
      w_i= column.i
      s_lst= s_lst||w_i||' '
   end

   row.= '' ; t_row= ''
   do i=1 to len
      w_i= word(s_lst,i)
      do j=1 to n_row
         row.j= row.j||substr(w_i,j,1)
      end
   end
   do j=1 to n_row; t_row= t_row||row.j; end

say "Sorted by columns:"||eol
call tab new_key, t_row

say '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'
say 'Encrypted message: '||s_lst
say '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'

exit
tab:
parse arg h, s, p  /* header, string, param */

   lh= length(h) ;
   s= h||copies('-',lh)||s ; ls= length(s)
   h=' -'||h

   t= ''  ; j= 1
   do i= 1 to ls by lh
      row= substr(s,i,lh)
      r_ch= ''
      do l=1 to lh
         ch= substr(row,l,1)
         r_ch= r_ch||ch||' '
      end
      row= r_ch
      if p <> '' then row= row||'|'||substr(h,j,1)
      t= t||row||eol
      j= j + 1
   end
   say t
return
