to filter(inList, acceptor)
  set outList to {}
  repeat with anItem in inList
    if acceptor's accept(anItem) then
      set end of outList to contents of anItem
    end
  end
  return outList
end

script isEven
  to accept(aNumber)
    aNumber mod 2 = 0
  end accept
end script

filter({1,2,3,4,5,6}, isEven)
