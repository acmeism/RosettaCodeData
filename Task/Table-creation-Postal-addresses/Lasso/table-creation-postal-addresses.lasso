// connect to a Mysql database
inline(-database = 'rosettatest', -sql = "CREATE TABLE `address` (
    `id`       int(11)     NOT NULL   auto_increment,
    `street`   varchar(50) NOT NULL   default '',
    `city`     varchar(25) NOT NULL   default '',
    `state`    char(2)     NOT NULL   default '',
    `zip`      char(10)    NOT NULL   default '',
    PRIMARY KEY (`id`)
);
") => {^
	error_msg
^}
