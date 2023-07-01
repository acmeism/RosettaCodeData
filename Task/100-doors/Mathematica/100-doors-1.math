n=100;
tmp=ConstantArray[-1,n];
Do[tmp[[i;;;;i]]*=-1;,{i,n}];
Do[Print["door ",i," is ",If[tmp[[i]]==-1,"closed","open"]],{i,1,Length[tmp]}]
