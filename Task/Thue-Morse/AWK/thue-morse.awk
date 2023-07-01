BEGIN{print x="0"}
{gsub(/./," &",x);gsub(/ 0/,"01",x);gsub(/ 1/,"10",x);print x}
