   % find all integers
   varlist = whos;
   ix = [strmatch('int', {varlist.class}),strmatch('uint', {varlist.class})];
   intsumall = 0;
   intsum = 0;
   for k=1:length(ix)
      if prod(varlist(ix).size)==1,
         intsum = intsum + eval(varlist.name);		% sum only integer scalars
      elseif prod(varlist(ix).size)>=1,
         tmp = eval(varlist.name);
         intsumall = intsumall + sum(tmp(:));		% sum all elements of integer array. 	
      end;
   end;
   printf('sum of integer scalars: %i\n',intsum);
   printf('sum of all integer elements: %i\n',intsumall);
