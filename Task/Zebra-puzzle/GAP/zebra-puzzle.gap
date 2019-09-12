leftOf  :=function(setA, vA, setB, vB)
local i;
for i in [1..4] do
   if ( setA[i] = vA) and  (setB[i+1] = vB) then return true ;fi;
od;
 return false;
end;

nextTo  :=function(setA, vA, setB, vB)
local i;
for i in [1..4] do
   if ( setA[i] = vA) and  (setB[i+1] = vB) then return true ;fi;
   if ( setB[i] = vB) and  (setA[i+1] = vA) then return true ;fi;
od;
return false;
end;


requires := function(setA, vA, setB, vB)
    local i;
      for i in [1..5] do
        if ( setA[i] = vA) and  (setB[i] = vB) then return true ;fi;
      od;
 return false;
end;


pcolors :=PermutationsList(["white" ,"yellow" ,"blue" ,"red" ,"green"]);
pcigars :=PermutationsList(["blends", "pall_mall", "prince", "bluemasters", "dunhill"]);
pnats:=PermutationsList(["german", "swedish", "british", "norwegian", "danish"]);
pdrinks :=PermutationsList(["beer", "water", "tea", "milk", "coffee"]);
ppets  :=PermutationsList(["birds", "cats", "horses", "fish", "dogs"]);


for colors in pcolors do
if not (leftOf(colors,"green",colors,"white")) then continue ;fi;
for nats in pnats do
if not (requires(nats,"british",colors,"red")) then  continue ;fi;
if not (nats[1]="norwegian") then continue ;fi;
if not (nextTo(nats,"norwegian",colors,"blue")) then continue ;fi;
for pets in ppets do
if not (requires(nats,"swedish",pets,"dogs")) then  continue ;fi;
for drinks in pdrinks do
if not (drinks[3]="milk") then continue ;fi;
if not (requires(colors,"green",drinks,"coffee")) then continue ;fi;
if not (requires(nats,"danish",drinks,"tea")) then  continue ;fi;
for cigars in pcigars do
if not (nextTo(pets,"horses",cigars,"dunhill")) then continue ;fi;
if not (requires(cigars,"pall_mall",pets,"birds")) then  continue ;fi;
if not (nextTo(cigars,"blends",drinks,"water")) then  continue ;fi;
if not (nextTo(cigars,"blends",pets,"cats")) then  continue ;fi;
if not (requires(nats,"german",cigars,"prince")) then  continue ;fi;
if not (requires(colors,"yellow",cigars,"dunhill")) then continue ;fi;
if not (requires(cigars,"bluemasters",drinks,"beer")) then  continue ;fi;
Print(colors,"\n");
Print(nats,"\n");
Print(drinks,"\n");
Print(pets,"\n");
Print(cigars,"\n");
od;od;od;od;od;
