class SuperDynamic
  @vars = {} of String => String | Int32

  def set_vars (@vars)
  end

  macro method_missing (call)
    {% name = call.name %}
    {% if name.ends_with? "=" %}
      {% name = name.gsub(/=$/, "") %}
      raise "unknown var" unless @vars.has_key? {{name.id.stringify}}
      @vars[{{name.id.stringify}}] = {{call.args[0].id}}
    {% else %}
      @vars[{{name.id.stringify}}]
    {% end %}
  end
end

sd = SuperDynamic.new

sd.set_vars({ "a" => 1, "b" => "2" })

p! sd.a
sd.a = 99
p! sd.a
