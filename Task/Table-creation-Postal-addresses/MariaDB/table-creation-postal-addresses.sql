CREATE OR REPLACE TABLE address_usa (
    uuid uuid DEFAULT uuid() PRIMARY KEY
        COMMENT 'This is more efficient than a text column',
    street varchar(100) NOT NULL,
    city varchar(100) NOT NULL,
    state varchar(100) CHECK (state > ''),
    zip char(5) NOT NULL CHECK (char_length(zip) = 5)
)
    ENGINE InnoDB,
    COMMENT 'This table is cool'
;
