filename = {% if flag?(:win32) %}
    "TAPE.FILE"
  {% else %}
    "/dev/tape"
  {% end %}
File.write filename, "howdy, planet!"
