  DS{1}.account='jsmith';
  DS{1}.password='x';
  DS{1}.UID=1001;
  DS{1}.GID=1000;
  DS{1}.fullname='Joe Smith';
  DS{1}.office='Room 1007';
  DS{1}.extension='(234)555-8917';
  DS{1}.homephone='(234)555-0077';
  DS{1}.email='jsmith@rosettacode.org';
  DS{1}.directory='/home/jsmith';
  DS{1}.shell='/bin/bash';

  DS{2}.account='jdoe';
  DS{2}.password='x';
  DS{2}.UID=1002;
  DS{2}.GID=1000;
  DS{2}.fullname='Jane Doe';
  DS{2}.office='Room 1004';
  DS{2}.extension='(234)555-8914';
  DS{2}.homephone='(234)555-0044';
  DS{2}.email='jdoe@rosettacode.org';
  DS{2}.directory='/home/jdoe';
  DS{2}.shell='/bin/bash';

  function WriteRecord(fid, rec)
     fprintf(fid,"%s:%s:%i:%i:%s,%s,%s,%s,%s:%s%s\n", rec.account, rec.password, rec.UID, rec.GID, rec.fullname, rec.office, rec.extension, rec.homephone, rec.email, rec.directory, rec.shell);
     return;
  end

  %% write
  fid = fopen('passwd.txt','w');
  WriteRecord(fid,DS{1});
  WriteRecord(fid,DS{2});
  fclose(fid);

  new.account='xyz';
  new.password='x';
  new.UID=1003;
  new.GID=1000;
  new.fullname='X Yz';
  new.office='Room 1003';
  new.extension='(234)555-8913';
  new.homephone='(234)555-0033';
  new.email='xyz@rosettacode.org';
  new.directory='/home/xyz';
  new.shell='/bin/bash';

  %% append
  fid = fopen('passwd.txt','a+');
  WriteRecord(fid,new);
  fclose(fid);

  % read password file
  fid = fopen('passwd.txt','r');
  while ~feof(fid)
	printf('%s\n',fgetl(fid));
  end;
  fclose(fid);
