 function notes(varargin)
    % NOTES can be used for taking notes
    % usage:
    %    notes    displays the content of the file NOTES.TXT
    %    notes arg1 arg2 ...
    %             add the current date, time and arg# to NOTES.TXT
    %

    filename = 'NOTES.TXT';
    if nargin==0
	fid = fopen(filename,'rt');
	if fid<0, return; end;
	while ~feof(fid)
		fprintf('%s\n',fgetl(fid));
	end;
	fclose(fid);
    else
        fid = fopen(filename,'a+');
	if fid<0, error('cannot open %s\n',filename); end;
        fprintf(fid, '%s\n\t%s', datestr(now),varargin{1});
        for k=2:length(varargin)
            fprintf(fid, ', %s', varargin{k});
	end;
	fprintf(fid,'\n');
	fclose(fid);
    end;
