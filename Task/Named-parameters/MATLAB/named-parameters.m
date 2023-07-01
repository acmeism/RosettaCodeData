   function foo(varargin)
      for k= 1:2:length(varargin);
         switch (varargin{k})
         case {'param1'}
            param1 = varargin{k+1};
         case {'param2'}
            param2 = varargin{k+1};
	 end;
      end;
      printf('param1: %s\n',param1);
      printf('param2: %s\n',param2);
   end;

   foo('param1','a1','param2','b2');
   foo('param2','b2','param1','a1');
