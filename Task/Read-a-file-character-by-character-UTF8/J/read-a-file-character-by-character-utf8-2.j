indexedread1u8=:4 :0
  try.
    octet0=. 1!:11 y;x,1
    octet0,1!:11 y;(x+1),<:u8len octet0
  catch.
    'EOF'
  end.
)
