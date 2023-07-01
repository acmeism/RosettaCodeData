function r = base_count(f)
    fid = fopen(f,'r');
    nn=[0,0,0,0];    	
    while ~feof(fid)
	s = fgetl(fid);
	fprintf(1,'%5d :%s\n', sum(nn), s(s=='A'|s=='C'|s=='G'|s=='T'));
	nn = nn+[sum(s=='A'),sum(s=='C'),sum(s=='G'),sum(s=='T')];
    end
    fclose(fid);

    fprintf(1, '\nBases:\n\n  A  : %d\n  C  : %d\n  G  : %d\n  T  : %d\n', nn);
    fprintf(1, '\nTotal: %d\n\n', sum(nn));
end;
