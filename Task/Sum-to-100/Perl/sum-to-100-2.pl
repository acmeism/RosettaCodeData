perl -E "say for grep{eval $_ == 100} glob '{-,}'.join '{+,-,}',1..9"
