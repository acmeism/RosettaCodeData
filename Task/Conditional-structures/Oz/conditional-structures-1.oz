proc {PrintParity X}
   if {IsEven X} then
      {Show even}
   elseif {IsOdd X} then
      {Show odd}
   else
      {Show 'should not happen'}
   end
end
