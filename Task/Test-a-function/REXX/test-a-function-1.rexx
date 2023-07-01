/*REXX program stresses various REXX functions (BIFs), many BIFs are used as variables. */
signal=(interpret=value); value=(interpret<parse); do upper=value to value; end
exit=upper*upper*upper*upper-value-upper; say=' '; return=say say say; with.=signal
do then=value to exit; pull=''; do otherwise= upper to then-,
value; select=otherwise-value; if.otherwise=with.otherwise+with.select; end
if.value=value; if.then=value; do otherwise=value to exit-then; pull=pull,
say''say; end; do otherwise=value to then; pull=pull center(if.otherwise,,
length(return)); end; say pull; do otherwise=value to exit; with.otherwise=,
if.otherwise; end; end; exit 0                   /*stick a fork in it,  we're all done. */
