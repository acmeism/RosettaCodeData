{$mode objFPC}
{$longStrings on}
{$modeSwitch classicProcVars+}

uses
	cTypes,
	// for system call wrappers
	unix;

const
	passwdPath = '/tmp/passwd';

resourceString
	advisoryLockFailed = 'Error: could not obtain advisory lock';

type
	GECOS = object
			fullname: string;
			office: string;
			extension: string;
			homephone: string;
			email: string;
			function asString: string;
		end;
	
	entry = object
			account: string;
			password: string;
			UID: cUInt;
			GID: cUInt;
			comment: GECOS;
			directory: string;
			shell: string;
			function asString: string;
		end;

function GECOS.asString: string;
const
	separator = ',';
begin
	with self do
	begin
		writeStr(result, fullname, separator, office, separator, extension,
			separator, homephone, separator, email);
	end;
end;

function entry.asString: string;
const
	separator = ':';
begin
	with self do
	begin
		writeStr(result, account, separator, password, separator, UID:1,
			separator, GID:1, separator, comment.asString, separator, directory,
			separator, shell);
	end;
end;
	
procedure writeEntry(var f: text; const value: entry);
begin
	writeLn(f, value.asString);
end;

procedure appendEntry(var f: text; const value: entry);
begin
	// (re-)open for writing and immediately seek to EOF
	append(f);
	writeEntry(f, value);
end;


// === MAIN ==============================================================
var
	passwd: text;

procedure releaseLock;
begin
	// equivalent to `exitCode := exitCode + …`
	inc(exitCode, fpFLock(passwd, lock_un));
end;

var
	user: entry;
	line: string;

begin
	assign(passwd, passwdPath);
	// open for reading
	reset(passwd);
	
	if fpFLock(passwd, lock_ex or lock_NB) <> 0 then
	begin
		writeLn(stdErr, advisoryLockFailed);
		halt(1);
	end;
	addExitProc(releaseLock);
	
	// reopen for _over_writing: immediately sets file size to 0
	rewrite(passwd);
	
	user.account := 'jsmith';
	user.password := 'x';
	user.UID := 1001;
	user.GID := 1000;
	user.comment.fullname := 'Joe Smith';
	user.comment.office := 'Room 1007';
	user.comment.extension := '(234)555-8917';
	user.comment.homephone := '(234)555-0077';
	user.comment.email := 'jsmith@rosettacode.org';
	user.directory := '/home/jsmith';
	user.shell := '/bin/bash';
	appendEntry(passwd, user);
	
	with user do
	begin
		account := 'jdoe';
		password := 'x';
		UID := 1002;
		GID := 1000;
		with comment do
		begin
			fullname := 'Jane Doe';
			office := 'Room 1004';
			extension := '(234)555-8914';
			homephone := '(234)555-0044';
			email := 'jdoe@rosettacode.org';
		end;
		directory := '/home/jdoe';
		shell := '/bin/bash';
	end;
	appendEntry(passwd, user);
	
	// Close the file, ...
	close(passwd);
	
	with user, user.comment do
	begin
		account := 'xyz';
		UID := 1003;
		fullname := 'X Yz';
		office := 'Room 1003';
		extension := '(234)555-8913';
		homephone := '(234)555-0033';
		email := 'xyz@rosettacode.org';
		directory := '/home/xyz';
	end;
	// ... then reopen the file for append.
	appendEntry(passwd, user);
	
	// open the file and demonstrate the new record has indeed written to the end
	reset(passwd);
	while not EOF(passwd) do
	begin
		readLn(passwd, line);
		writeLn(line);
	end;
end.
