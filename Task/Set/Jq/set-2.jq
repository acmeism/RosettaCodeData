def is_stringset:
  . as $in | type == "object" and reduce keys[] as $key (true; . and $in[$key] == true);
