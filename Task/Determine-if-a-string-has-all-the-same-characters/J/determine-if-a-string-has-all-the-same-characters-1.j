require'convert'
task=: {{
  if. 1>:#t=. ~.y do.
    echo 'all ',(":#y),' character(s) same in "',y,'"'
  else.
    j=. ":1+y i. ch=.1{t
    echo '"',ch,'" (hex: ',(hfd 3 u:ch),', character ',j,' of ',(":#y),') differs from previous characters in "',y,'"'
  end.
}}
