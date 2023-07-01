# objectify/1 takes an array of atomic values as inputs, and packages
# these into an object with keys specified by the "headers" array and
# values obtained by trimming string values, replacing empty strings
# by null, and converting strings to numbers if possible.
def objectify(headers):
  def tonumberq: tonumber? // .;
  def trimq: if type == "string" then sub("^ +";"") | sub(" +$";"") else . end;
  def tonullq: if . == "" then null else . end;
  . as $in
  | reduce range(0; headers|length) as $i
      ({}; .[headers[$i]] = ($in[$i] | trimq | tonumberq | tonullq) );

def csv2jsonHelper:
  .[0] as $headers
  | reduce (.[1:][] | select(length > 0) ) as $row
      ([]; . + [ $row|objectify($headers) ]);
