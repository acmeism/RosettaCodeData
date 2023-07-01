#!/usr/bin/env jq -M -R -r -f
# or perhaps:
#!/usr/local/bin/jq -M -R -r -f

# If your operating system does not allow more than one option
# to be specified on the command line,
# then consider using a version of jq that allows
# command-line options to be squished together (-MRrf),
# or see the following subsection.

def rot13:
  explode
 | map( if 65 <= . and . <= 90 then ((. - 52) % 26) + 65
        elif 97 <= . and . <= 122 then (. - 84) % 26 + 97
        else .
   end)
 | implode;

rot13
