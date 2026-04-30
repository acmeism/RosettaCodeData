class Amb
  @sels = [] of ASel

  def sel (options : Array(T)) forall T
    s = Sel(T).new(options)
    @sels << s
    s
  end

  def assert (&)
    from = @sels.map {|s| s.fixed? ? s.index : 0 }
    to =   @sels.map {|s| s.fixed? ? s.index : s.option_count - 1 }
    indices = from.dup

    loop do
      begin
        @sels.zip(indices).each do |sel, idx| sel.set_option_no(idx) end
        success = yield
      rescue
        success = false
      end
      break if success
      (0..indices.size).each do |i|
        if i == indices.size
          raise Error.new("Couldn't find values to make the expression be true")
        end
        if indices[i] < to[i]
          indices[i] += 1
          break
        else
          indices[i] = from[i]
        end
      end
    end
    @sels.each do |s| s.fix! end
  end

  class Error < Exception
  end

  abstract class ASel
  end

  class Sel (T) < ASel
    @options : Array(T)
    getter index = 0
    getter? fixed = false

    def initialize (options)
      @options = options.dup
    end

    def set_option_no (@index)
    end

    def fix!
      @fixed = true
    end

    def option_count
      @options.size
    end

    def current_value
      @options[@index]
    end

    def to_s (io)
      if @fixed
        @options[@index].to_s(io)
      else
        io << '{' << @options.join(",") << "}"
      end
    end

    macro method_missing (call)
      {% for arg, i in call.args %}
        param{{i.id}} = {{arg.id}}
      {% end %}
      @options[@index].{{call.name}}(
        {{(0...call.args.size).map {|i| "param#{i}.is_a?(ASel) ? param#{i}.current_value : param#{i}".id }.splat}}
      )
    end
  end
end

macro show_vars (*vars)
  {% for v in vars %}
    print {{v.stringify}}, " = ", {{v}}.to_s, "\n"
  {% end %}
end

amb = Amb.new

a = amb.sel %w(the that a)
b = amb.sel %w(frog elephant thing)
c = amb.sel %w(walked treaded grows)
d = amb.sel %w(slowly quickly)

puts "before:"
show_vars a, b, c, d

amb.assert {
  [a, b, c, d].each.cons_pair.all? {|x, y| x[-1] == y[0] }
}

puts "\nafter:"
show_vars a, b, c, d
