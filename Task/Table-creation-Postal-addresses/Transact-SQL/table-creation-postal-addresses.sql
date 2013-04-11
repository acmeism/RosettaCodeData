CREATE TABLE #Address (
    addrID       int        NOT NULL   Identity(1,1) PRIMARY KEY,
    addrStreet   varchar(50) NOT NULL ,
    addrCity     varchar(25) NOT NULL ,
    addrState    char(2)     NOT NULL ,
    addrZIP      char(10)    NOT NULL
)
drop table #Address
