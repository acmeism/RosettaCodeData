var doors=[];
for (var i=0;i<100;i++)
    doors[i]=false;
for (var i=1;i<=100;i++)
    for (var i2=i-1;i2<100;i2+=i)
        doors[i2]=!doors[i2];
for (var i=1;i<=100;i++)
    console.log("Door %d is %s",i,doors[i-1]?"open":"closed")
