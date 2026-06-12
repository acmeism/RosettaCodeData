xp=127;
yp=127;
na=0;
x=[];
y=[];
e=[];
d=-1;
f=randi([1,4]);

while d~=5

 a=na+1;
 for n=1:na
  if x(n)==xp && y(n)==yp
   a=n;
   break
   end
 end

 if (a==na+1)
  na=na+1;
  x=[x,xp];
  y=[y,yp];
  for n=1:4
   e=[e,logical(randi([0,1]))];
   end
  for n=1:na
   if (x(n)==x(a)+1) && (y(n)==y(a))
    e(1+4*(a-1))=e(1+4*(n-1)+2);
    end
   if (x(n)==x(a)) && (y(n)==y(a)+1)
    e(1+4*(a-1)+1)=e(1+4*(n-1)+3);
    end
   if (x(n)==x(a)-1) && (y(n)==y(a))
    e(1+4*(a-1)+2)=e(1+4*(n-1));
    end
   if (x(n)==x(a)) && (y(n)==y(a)-1)
    e(1+4*(a-1)+3)=e(1+4*(n-1)+1);
    end
   end
  end

 str = "Paths:";
 if e(1+4*(a-1)+(f-1))
  str = strcat(str," ahead");
  end
 if e(1+4*(a-1)+mod((f-1)+1,4))
  str = strcat(str," right");
  end
 if e(1+4*(a-1)+mod((f-1)+2,4))
  str = strcat(str," back");
  end
 if e(1+4*(a-1)+mod((f-1)+3,4))
  str = strcat(str," left");
  end
 disp(str)

 d=-1;
 while d<0
  entry=input("What? ","s");
  if entry=="ahead"
   d=f;
   elseif entry == "right"
   d=mod((f-1)+1,4)+1;
   elseif entry == "back"
   d=mod((f-1)+2,4)+1;
   elseif entry == "left"
   d=mod((f-1)+3,4)+1;
   elseif entry=="quit"
   d=5;
   end
  end

 if (d>0) && (d<5)
  switch d
   case 1
    if e(1+(a-1)*4)
     xp=xp+1;
     end
   case 2
    if e(1+(a-1)*4+1)
     yp=yp+1;
     end
   case 3
    if e(1+(a-1)*4+2)
     xp=xp-1;
     end
   case 4
    if e(1+(a-1)*4+3)
     yp=yp-1;
     end
   end
   f=d;
  end

 end
