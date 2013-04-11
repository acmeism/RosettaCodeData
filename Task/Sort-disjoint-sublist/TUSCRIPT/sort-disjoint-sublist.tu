$$ MODE TUSCRIPT
values="7'6'5'4'3'2'1'0"
indices="7'2'8"
v_unsorted=SELECT (values,#indices)
v_sort=DIGIT_SORT (v_unsorted)
i_sort=DIGIT_SORT (indices)
LOOP i=i_sort,v=v_sort
values=REPLACE (values,#i,v)
ENDLOOP
PRINT values
