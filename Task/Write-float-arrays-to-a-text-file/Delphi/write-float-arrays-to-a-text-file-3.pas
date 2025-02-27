.header off
.mode list
.output output.tsv
select format('{:.3f}', x) || chr(9) || format('{:.5f}', y) from t;
.output
.shell cat output.tsv
