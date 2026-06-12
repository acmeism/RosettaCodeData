kmp_table=: {{
  j=. 0
  T=. _1
  for_ch. }.y do.
    if. ch=j{y do.
      T=. T,j{T
    else.
      T=. T,j while. (0<:j) * ch~:j{y do. j=. j{T end.
    end.
    j=. j+1
  end.
  T=. T, j
}}

kmp_search=: {{
  b=. 0#~#y
  k=. _1
  f=. _1+#x
  T=. kmp_table x
  for_ch. y do.
    if. ch=x{~k=.k+1 do.
      if. f=k do.
        b=. 1 (ch_index-k)} b
        k=. k{T
      end.
    else.
      whilst. _1<k do.
        if. ch=x{~k=. k{T do. break. end.
      end.
    end.
  end.
  I. b
}}
