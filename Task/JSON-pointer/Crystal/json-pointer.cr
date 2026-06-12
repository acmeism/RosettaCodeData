require "json"

struct JSON::Any
  def pointer_get (pointer)
    return self if pointer == ""
    o = self
    split_pointer(pointer).each do |index|
      o = case o.raw
          when Array
            o[index.to_i(whitespace: false)]
          when Hash
            o[index]
          else
            raise ArgumentError.new("pointer too long")
          end
    end
    o
  end

  private def split_pointer (s)
    raise ArgumentError.new("invalid pointer") unless s.starts_with?('/')
    s.lchop('/').split('/').map {|link| link.gsub(/~[01]/, {"~0": "~", "~1": "/"}) }
  end
end

doc = JSON.parse <<-JSON
{
  "wiki": {
    "links": [
      "https://rosettacode.org/wiki/Rosetta_Code",
      "https://discord.com/channels/1011262808001880065"
    ]
  },
  "": "Rosetta",
  " ": "Code",
  "g/h": "chrestomathy",
  "i~j": "site",
  "abc": ["is", "a"],
  "def": { "": "programming" }
}
JSON

pointers = ["", "/", "/ ", "/abc", "/def/", "/g~1h", "/i~0j",
            "/wiki/links/0", "/wiki/links/1", "/wiki/links/2",
            "/wiki/name", "/no/such/thing", "bad/pointer"]
width = pointers.max_of(&.inspect.size)

pointers.each do |pointer|
  print pointer.inspect.ljust(width), " ",
        begin
          doc.pointer_get(pointer).inspect
        rescue ex
          "** ERROR: #{ex.message}"
        end, "\n"
end
