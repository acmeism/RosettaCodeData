require 'tk'
$str = TkVariable.new("Hello World! ")
$dir = :right

def animate
  $str.value = shift_char($str.value, $dir)
  $root.after(125) {animate}
end

def shift_char(str, dir)
  case dir
  when :right then str[-1,1] + str[0..-2]
  when :left  then str[1..-1] + str[0,1]
  end
end

$root = TkRoot.new("title" => "Basic Animation")

TkLabel.new($root) do
  textvariable $str
  font "Courier 14"
  pack {side 'top'}
  bind("ButtonPress-1") {$dir = {:right=>:left,:left=>:right}[$dir]}
end

animate
Tk.mainloop
