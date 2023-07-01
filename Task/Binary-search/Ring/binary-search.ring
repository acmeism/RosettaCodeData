decimals(0)
array = [7, 14, 21, 28, 35, 42, 49, 56, 63, 70]

find= 42
index = where(array,find,0,len(array))
if index >= 0
   see "the value " + find+ " was found at index " + index
else
   see "the value " + find + " was not found"
ok

func where(a,s,b,t)
     h = 2
     while h<(t-b)
           h *= 2
     end
     h /= 2
     while h != 0
           if (b+h)<=t
              if s>=a[b+h]
                 b += h
              ok
           ok
           h /= 2
     end
     if s=a[b]
        return b-1
     else
        return -1
     ok
