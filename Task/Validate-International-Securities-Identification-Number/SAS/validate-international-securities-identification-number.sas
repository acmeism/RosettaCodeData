data test;
length isin $20 ok $1;
input isin;
keep isin ok;
array s{24};
link isin;
return;
isin:
ok="N";
n=length(isin);
if n=12 then do;
    j=0;
    do i=1 to n;
        k=rank(substr(isin,i,1));
        if k>=48 & k<=57 then do;
            if i<3 then return;
            j+1;
            s{j}=k-48;
        end;
        else if k>=65 & k<=90 then do;
            if i=12 then return;
            k+-55;
            j+1;
            s{j}=int(k/10);
            j+1;
            s{j}=mod(k,10);
        end;
        else return;
    end;

    v=sum(of s{*});
    do i=j-1 to 1 by -2;
        v+s{i}-9*(s{i}>4);
    end;

if mod(v,10)=0 then ok="Y";
end;
return;
cards;
US0378331005
US0373831005
U50378331005
US03378331005
AU0000XVGZA3
AU0000VXGZA3
FR0000988040
;
run;
