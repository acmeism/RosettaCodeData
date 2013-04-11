   % convert version into numerical value
   v = version;
   v(v=='.')=' ';
   v = str2num(v);
   if v(2)>10; v(2) = v(2)/10; end;
   ver = v(1)+v(2)/10;
   if exist('OCTAVE_VERSION','builtin')
      if ver < 3.0,
         exit
      end;
   else
      if ver < 7.0,
         exit
      end;
   end	

   % test variable bloob, and test whether function abs is defined as m-function, mex-function or builtin-function
   if exist('bloob','var') && any(exist('abs')==[2,3,5])
	printf('abs(bloob) is %f\n',abs(bloob));
	return;
   end;
