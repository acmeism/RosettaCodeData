create or replace table neat (x DECIMAL(38,3), y DECIMAL(38,5));
insert into neat from t;
from neat;
copy neat to 'output.tsv' (HEADER true, DELIMITER '\t');
.shell cat output.tsv
