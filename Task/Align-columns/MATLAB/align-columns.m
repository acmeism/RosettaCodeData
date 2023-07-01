function r = align_columns(f)
    fid = fopen('align_column_data.txt', 'r');
    D   = {};
    M   = 0;
    while ~feof(fid)
        s = fgetl(fid);
        strsplit(s,'$');
	m = diff([0,find(s=='$')])-1;
	M = max([M,zeros(1,length(m)-length(M))], [m,zeros(1,length(M)-length(m))]);
        D{end+1}=s;
    end
    fclose(fid);

    fprintf(1,'%%-- right-justified --%%\n')
    FMT = sprintf('%%%ds ',M);
    for k=1:length(D)
	d = strsplit(D{k},'$');
        fprintf(1,FMT,d{:});
        fprintf(1,'\n');
    end

    fprintf(1,'%%-- left-justified --%%\n')
    FMT = sprintf('%%-%ds ',M);
    for k=1:length(D)
	d = strsplit(D{k},'$');
        fprintf(1,FMT,d{:});
        fprintf(1,'\n');
    end
end;
