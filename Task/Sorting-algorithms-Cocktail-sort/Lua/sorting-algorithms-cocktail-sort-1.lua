function cocktailSort( A )
  local swapped
  repeat
    swapped = false
    for i = 1, #A - 1 do
      if A[ i ] > A[ i+1 ] then
         A[ i ], A[ i+1 ] = A[ i+1 ] ,A[i]
         swapped=true
	   end
    end
    if swapped == false then
      break -- repeatd loop;
	end

     for i = #A - 1,1,-1 do
      if A[ i ] > A[ i+1 ] then
         A[ i ], A[ i+1 ] = A[ i+1 ] , A[ i ]
         swapped=true
	   end
    end

  until swapped==false
end
