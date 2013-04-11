require"re"

record = re.compile[[
  record <- ( <field> (',' <field>)* ) -> {} (%nl / !.)
  field <- <escaped> / <nonescaped>
  nonescaped <- { [^,"%nl]* }
  escaped <- '"' {~ ([^"] / '""' -> '"')* ~} '"'
]]

print(unpack(record:match"hello,how,are,you,today"))
