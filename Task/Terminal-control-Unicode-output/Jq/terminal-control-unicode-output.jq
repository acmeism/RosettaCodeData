def has_unicode_support:
  def utf: if . == null then false else contains("UTF") or contains("utf") end;
  env.LC_ALL
  | if utf then true
    elif . != null and . != "" then false
    elif env.LC_CTYPE | utf then true
    else env.LANG | utf
    end ;

def task:
  if has_unicode_support then "\u25b3"
  else error("HW65001 This program requires a Unicode-compatible terminal")
  end ;

task
