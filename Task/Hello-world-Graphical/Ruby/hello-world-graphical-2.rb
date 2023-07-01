require 'tk'
root = TkRoot.new("title" => "User Output")
TkLabel.new(root, "text"=>"CHUNKY BACON!").pack("side"=>'top')
Tk.mainloop
