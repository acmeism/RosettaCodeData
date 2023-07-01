function one_dim_cell_automata(v,n)
   V='_#';
   while n>=0;
	disp(V(v+1));
	n = n-1;
	v = filter([1,1,1],1,[0,v,0]);
	v = v(3:end)==2;
   end;
end
