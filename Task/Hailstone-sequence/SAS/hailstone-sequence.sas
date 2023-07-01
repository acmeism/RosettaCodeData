* Create a routine to generate the hailstone sequence for one number;
%macro gen_seq(n);
   data hailstone;
      array hs_seq(100000);
      n=&n;
      do until (n=1);
         seq_size + 1;
         hs_seq(seq_size) = n;
         if mod(n,2)=0 then n=n/2;
         else n=(3*n)+1;
      end;
	  seq_size + 1;
      hs_seq(seq_size)=n;
	  call symputx('seq_length',seq_size);
   run;

   proc sql;
      title "First and last elements of Hailstone Sequence for number &n";
	  select seq_size as sequence_length, hs_seq1, hs_seq2, hs_seq3, hs_seq4
			%do i=&seq_length-3 %to &seq_length;
				, hs_seq&i
			%end;
		from hailstone;
	quit;
%mend;

* Use the routine to output the first and last four numbers in the sequence for 27;
%gen_seq(27);

* Show the number less than 100,000 which has the longest hailstone sequence, and what that length is ;
%macro longest_hailstone(start_num, end_num);
	data hailstone_analysis;
	  do start=&start_num to &end_num;
	    n=start;
		length_of_sequence=1;
		do while (n>1);
		  length_of_sequence+1;
		  if mod(n,2)=0 then n=n/2;
		  else n=(3*n) + 1;
		end;
		output;
	  end;
	run;

	proc sort data=hailstone_analysis;
	  by descending length_of_sequence;
	run;

	proc print data=hailstone_analysis (obs=1) noobs;
	  title "Number from &start_num to &end_num with longest Hailstone sequence";
	  var start length_of_sequence;
	run;
%mend;
%longest_hailstone(1,99999);
