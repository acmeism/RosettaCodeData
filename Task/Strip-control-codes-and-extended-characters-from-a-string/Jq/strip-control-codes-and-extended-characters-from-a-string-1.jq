def strip_control_codes:
 explode | map(select(. > 31 and . != 127)) | implode;

def strip_extended_characters:
  explode | map(select(31 < . and . < 127)) | implode;
