MODE ADDRESS = STRUCT(
	INT page,
	FLEX[50]CHAR street,
	FLEX[25]CHAR city,
	FLEX[2]CHAR state,
	FLEX[10]CHAR zip
);
FORMAT address repr = $"Page: "gl"Street: "gl"City: "gl"State: "gl"Zip: "gll$;

INT errno;
FILE sequence; errno := open(sequence, "sequence.txt", stand back channel);
SEMA sequence sema := LEVEL 1;

OP NEXTVAL = ([]CHAR table name)INT: (
  INT out;
  # INT table page = 0; # # only one sequence implemented #
  # DOWN sequence sema; # # NO interprocess concurrency protection #
    on open error(sequence,
      (REF FILE f)BOOL: (
        reset(sequence); #set(table page,1,1);#
        put(sequence, 0);
        try again;
        FALSE
      )
    );
    try again:
    reset(sequence); #set(table page,1,1);# get(sequence,out);
    out +:=1;
    reset(sequence); #set(table page,1,1);# put(sequence,out);
  # UP sequence sema; #
  out
);

OP INIT = (REF ADDRESS self)REF ADDRESS: ( page OF self := NEXTVAL "address"; self);

REF ADDRESS john brown = INIT LOC ADDRESS;

john brown := (page OF john brown, "10 Downing Street","London","England","SW1A 2AA");

printf((address repr, john brown));

FILE address table;
errno := open(address table,"address.txt",stand back channel);
# set(address table, page OF john brown,1,1);  - standard set page not available in a68g #
put bin(address table, john brown);
close(address table)
