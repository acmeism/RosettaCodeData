require 'tempfile'

f = Tempfile.new('foo')
f.path  # => "/tmp/foo20081226-307-10p746n-0"
f.close
f.unlink # => #<Tempfile: (closed)>
