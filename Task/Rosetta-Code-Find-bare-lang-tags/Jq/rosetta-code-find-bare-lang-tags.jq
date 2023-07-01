def lpad($len): tostring | ($len - length) as $l | (" " * $l)[:$l] + .;

def trim: sub("^[ \t]+";"") | sub("[ \t]+$";"");

# Insert into a sorted list using bsearch
def binsert($x):
  (-bsearch($x) - 1) as $ix
  | if $ix < 0 then .
    else .[:$ix] + [$x] + .[$ix:]
    end;

def report:
  def header:
    "==\\s*{{\\s*header\\s*\\|\\s*(?<title>[^\\s\\}]+)\\s*}}\\s*==";

  reduce inputs as $line ( { bareCount:0, bareLang: {} };
      if .fileName != input_filename
      then .lastHeader = "No language"
      | .fileName = input_filename
      else .
      end
      | .line = ($line|trim)
      |  if .line | length == 0 then .
         else .header = ((.line | capture(header)) // null)
         | if .header
           then .lastHeader = .header.title
           elif .line|startswith("<lang>")
           then .bareCount += 1
           | .bareLang[.lastHeader][0] += 1
           | .fileName as $fileName
           | .bareLang[.lastHeader][1] |= binsert($fileName)
           else .
           end
         end )
  | "\(.bareCount) bare language tags:",
    (.bareLang
     | to_entries[] as {"key": $lang, "value": $value}
     | $value[0] as $count
     | $value[1] as $names
     | ("\($count|lpad(3)) in \($lang|lpad(15))" + ": " + ($names | join(", ")) )) ;

report
