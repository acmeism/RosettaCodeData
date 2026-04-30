' Knapsack problem/0-1 - 13/02/2017
dim w(22),v(22),m(22)
data=array( "map", 9, 150, "compass", 13, 35, "water", 153, 200, _
 "sandwich", 50, 160 , "glucose", 15, 60, "tin", 68, 45, _
 "banana", 27, 60, "apple", 39, 40 , "cheese", 23, 30, "beer", 52, 10, _
 "suntan cream", 11, 70, "camera", 32, 30 , "T-shirt", 24, 15, _
 "trousers", 48, 10, "umbrella", 73, 40, "book", 30, 10 , _
 "waterproof trousers", 42, 70, "waterproof overclothes", 43, 75 , _
 "note-case", 22, 80, "sunglasses", 7, 20, "towel", 18, 12, "socks", 4, 50)
ww=400
xw=0:iw=0:iv=0
w(1)=iw:v(1)=iv
for i1=0 to 1:m(1)=i1:j=0
 if i1=1 then
  iw=w(1)+data(j*3+1):iv=v(1)+data(j*3+2)
  if iv>xv and iw<=ww then xw=iw:xv=iv:l=m
 end if 'i1
 if iw<=ww then
  w(2)=iw: v(2)=iv
  for i2=0 to 1:m(2)=i2:j=1
   if i2=1 then
    iw=w(2)+data(j*3+1):iv=v(2)+data(j*3+2)
    if iv>xv and iw<=ww then xw=iw:xv=iv:l=m
   end if 'i2
   if iw<=ww then
    w(3)=iw: v(3)=iv
    for i3=0 to 1:m(3)=i3:j=2
     if i3=1 then
      iw=w(3)+data(j*3+1):iv=v(3)+data(j*3+2)
      if iv>xv and iw<=ww then xw=iw:xv=iv:l=m
     end if 'i3
     if iw<=ww then
      w(4)=iw: v(4)=iv
      for i4=0 to 1:m(4)=i4:j=3
       if i4=1 then
        iw=w(4)+data(j*3+1):iv=v(4)+data(j*3+2)
        if iv>xv and iw<=ww then xw=iw:xv=iv:l=m
       end if 'i4
       if iw<=ww then
        w(5)=iw: v(5)=iv
        for i5=0 to 1:m(5)=i5:j=4
         if i5=1 then
          iw=w(5)+data(j*3+1):iv=v(5)+data(j*3+2)
          if iv>xv and iw<=ww then xw=iw:xv=iv:l=m
         end if 'i5
         if iw<=ww then
          w(6)=iw: v(6)=iv
          for i6=0 to 1:m(6)=i6:j=5
           if i6=1 then
            iw=w(6)+data(j*3+1):iv=v(6)+data(j*3+2)
            if iv>xv and iw<=ww then xw=iw:xv=iv:l=m
           end if 'i6
           if iw<=ww then
            w(7)=iw: v(7)=iv
            for i7=0 to 1:m(7)=i7:j=6
             if i7=1 then
              iw=w(7)+data(j*3+1):iv=v(7)+data(j*3+2)
              if iv>xv and iw<=ww then xw=iw:xv=iv:l=m
             end if 'i7
             if iw<=ww then
              w(8)=iw: v(8)=iv
              for i8=0 to 1:m(8)=i8:j=7
               if i8=1 then
                iw=w(8)+data(j*3+1):iv=v(8)+data(j*3+2)
                if iv>xv and iw<=ww then xw=iw:xv=iv:l=m
               end if 'i8
               if iw<=ww then
                w(9)=iw: v(9)=iv
                for i9=0 to 1:m(9)=i9:j=8
                 if i9=1 then
                  iw=w(9)+data(j*3+1):iv=v(9)+data(j*3+2)
                  if iv>xv and iw<=ww then xw=iw:xv=iv:l=m
                 end if 'i9
                 if iw<=ww then
                  w(10)=iw: v(10)=iv
                  for i10=0 to 1:m(10)=i10:j=9
                   if i10=1 then
                    iw=w(10)+data(j*3+1):iv=v(10)+data(j*3+2)
                    if iv>xv and iw<=ww then xw=iw:xv=iv:l=m
                   end if 'i10
                   if iw<=ww then
                    w(11)=iw: v(11)=iv
                    for i11=0 to 1:m(11)=i11:j=10
                     if i11=1 then
                      iw=w(11)+data(j*3+1):iv=v(11)+data(j*3+2)
                      if iv>xv and iw<=ww then xw=iw:xv=iv:l=m
                     end if 'i11
                     if iw<=ww then
                      w(12)=iw: v(12)=iv
                      for i12=0 to 1:m(12)=i12:j=11
                       if i12=1 then
                        iw=w(12)+data(j*3+1):iv=v(12)+data(j*3+2)
                        if iv>xv and iw<=ww then xw=iw:xv=iv:l=m
                       end if 'i12
                       if iw<=ww then
                        w(13)=iw: v(13)=iv
                        for i13=0 to 1:m(13)=i13:j=12
                         if i13=1 then
                          iw=w(13)+data(j*3+1):iv=v(13)+data(j*3+2)
                          if iv>xv and iw<=ww then xw=iw:xv=iv:l=m
                         end if 'i13
                         if iw<=ww then
                          w(14)=iw: v(14)=iv
                          for i14=0 to 1:m(14)=i14:j=13
                           if i14=1 then
                            iw=w(14)+data(j*3+1):iv=v(14)+data(j*3+2)
                            if iv>xv and iw<=ww then xw=iw:xv=iv:l=m
                           end if 'i14
                           if iw<=ww then
                            w(15)=iw: v(15)=iv
                            for i15=0 to 1:m(15)=i15:j=14
                             if i15=1 then
                              iw=w(15)+data(j*3+1):iv=v(15)+data(j*3+2)
                              if iv>xv and iw<=ww then xw=iw:xv=iv:l=m
                             end if 'i15
                             if iw<=ww then
                              w(16)=iw: v(16)=iv
                              for i16=0 to 1:m(16)=i16:j=15
                               if i16=1 then
                                iw=w(16)+data(j*3+1):iv=v(16)+data(j*3+2)
                                if iv>xv and iw<=ww then xw=iw:xv=iv:l=m
                               end if 'i16
                               if iw<=ww then
                                w(17)=iw: v(17)=iv
                                for i17=0 to 1:m(17)=i17:j=16
                                 if i17=1 then
                                  iw=w(17)+data(j*3+1):iv=v(17)+data(j*3+2)
                                  if iv>xv and iw<=ww then xw=iw:xv=iv:l=m
                                 end if 'i17
                                 if iw<=ww then
                                  w(18)=iw: v(18)=iv
                                  for i18=0 to 1:m(18)=i18:j=17
                                   if i18=1 then
                                    iw=w(18)+data(j*3+1):iv=v(18)+data(j*3+2)
                                    if iv>xv and iw<=ww then xw=iw:xv=iv:l=m
                                   end if 'i18
                                   if iw<=ww then
                                    w(19)=iw: v(19)=iv
                                    for i19=0 to 1:m(19)=i19:j=18
                                     if i19=1 then
                                      iw=w(19)+data(j*3+1):iv=v(19)+data(j*3+2)
                                      if iv>xv and iw<=ww then xw=iw:xv=iv:l=m
                                     end if 'i19
                                     if iw<=ww then
                                      w(20)=iw: v(20)=iv
                                      for i20=0 to 1:m(20)=i20:j=19
                                       if i20=1 then
                                        iw=w(20)+data(j*3+1):iv=v(20)+data(j*3+2)
                                        if iv>xv and iw<=ww then xw=iw:xv=iv:l=m
                                       end if 'i20
                                       if iw<=ww then
                                        w(21)=iw: v(21)=iv
                                        for i21=0 to 1:m(21)=i21:j=20
                                         if i21=1 then
                                          iw=w(21)+data(j*3+1):iv=v(21)+data(j*3+2)
                                          if iv>xv and iw<=ww then xw=iw:xv=iv:l=m
                                         end if 'i21
                                         if iw<=ww then
                                          w(22)=iw: v(22)=iv
                                          for i22=0 to 1:m(22)=i22:j=21
                                           nn=nn+1
                                           if i22=1 then
                                            iw=w(22)+data(j*3+1):iv=v(22)+data(j*3+2)
                                            if iv>xv and iw<=ww then xw=iw:xv=iv:l=m
                                           end if 'i22
                                           if iw<=ww then
                                           end if 'i22
                                          next:m(22)=0
                                         end if 'i21
                                        next:m(21)=0
                                       end if 'i20
                                      next:m(20)=0
                                     end if 'i19
                                    next:m(19)=0
                                   end if 'i18
                                  next:m(18)=0
                                 end if 'i17
                                next:m(17)=0
                               end if 'i16
                              next:m(16)=0
                             end if 'i15
                            next:m(15)=0
                           end if 'i14
                          next:m(14)=0
                         end if 'i13
                        next:m(13)=0
                       end if 'i12
                      next:m(12)=0
                     end if 'i11
                    next:m(11)=0
                   end if 'i10
                  next:m(10)=0
                 end if 'i9
                next:m(9)=0
               end if 'i8
              next:m(8)=0
             end if 'i7
            next:m(7)=0
           end if 'i6
          next:m(6)=0
         end if 'i5
        next:m(5)=0
       end if 'i4
      next:m(4)=0
     end if 'i3
    next:m(3)=0
   end if 'i2
  next:m(2)=0
 end if 'i1
next:m(1)=0
for i=1 to 22
 if l(i)=1 then wlist=wlist&vbCrlf&data((i-1)*3)
next
Msgbox mid(wlist,3)&vbCrlf&vbCrlf&"weight="&xw&vbCrlf&"value="&xv,,"Knapsack - nn="&nn
