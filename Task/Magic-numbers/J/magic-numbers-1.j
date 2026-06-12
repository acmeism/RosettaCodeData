ispdiv=: {{0= +/(# | 10 #. ])\ 10&#.inv y}}

{{
 if. 0>nc<'pdivs' do.
  pdivs=: {{
   r=. 0,d=. 1 2 3 4 5 6 7 8 9x
   while. #d do.
     r=. r,d=. (#~ ispdiv"0), (10*d)+/i.10
   end.
  }}0
 end.
}}0
