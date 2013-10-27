function S=range_extraction(L)
% Range extraction
L(end+1) = NaN;
S = int2str(L(1));
k = 1;
while (k < length(L)-1)
	if (L(k)+1==L(k+1) && L(k)+2==L(k+2) )
		m = 2;
    		while (L(k)+m==L(k+m))
         		m = m+1;
          	end;
    		k = k+m-1;
    		S = [S,'-',int2str(L(k))];
    	else
    		k = k+1;
    		S = [S,',',int2str(L(k))];
    	end 	
end;
