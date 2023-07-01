  % Initialize
  N = 0; S=0; S2 = 0;
  binlist = 0:.1:1;	
  h = zeros(1,length(binlist));  % initialize histogram

  % read data and perform computation
  while (1)
	% read next sample x
        if (no_data_available) break; end;
        N = N + 1;
        S = S + x;
        S2= S2+ x*x;
        ix= sum(x < binlist);
        h(ix) = h(ix)+1;
  end 	

  % generate output
  m  = S/N;   % mean
  sd = sqrt(S2/N-mean*mean);  % standard deviation
  bar(binlist,h)
