def file_extension:
  def alphanumeric: explode | unique
  | reduce .[] as $i
      (true;
       if . then $i | (97 <= . and . <= 122) or (65 <= . and . <= 90) or (48 <= . and . <= 57)
       else false
       end );
  rindex(".") as $ix
  | if $ix then .[1+$ix:] as $ext
    | if $ext|alphanumeric then ".\($ext)" # include the period
      else ""
      end
    else ""
    end;
