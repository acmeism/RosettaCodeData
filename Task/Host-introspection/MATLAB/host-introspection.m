  function [endian]=endian()
    fid=tmpfile();
    fwrite(fid,1:8,'uint8');

    fseek(fid,0,'bof');
    t=fread(fid,8,'int8');
    i8=sprintf('%02X',t);

    fseek(fid,0,'bof');
    t=fread(fid,4,'int16');
    i16=sprintf('%04X',t);

    fclose(fid);

    if strcmp(i8,i16) endian='big';
    else endian='little';
    end;
