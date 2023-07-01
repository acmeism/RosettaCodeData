# Rakefile

# To build and run:
#   $ rake
#   $ ./callruby

# Must link with cc -Wl,-E so query.c exports QueryPointer.
CC = ENV.fetch('CC', 'cc')
LDFLAGS = '-Wl,-E'
CPPFLAGS = RbConfig.expand('-I$(rubyarchhdrdir) -I$(rubyhdrdir)')
LIBS = RbConfig.expand('$(LIBRUBYARG) $(LIBS)')

task 'default' => 'callruby'

desc 'compiles callruby'
file 'callruby' => %w[main.o query-rb.o] do |t|
  sh "#{CC} #{LDFLAGS} -o #{t.name} #{t.sources.join(' ')} #{LIBS}"
end

rule '.o' => %w[.c] do |t|
  sh "#{CC} #{CPPFLAGS} -o #{t.name} -c #{t.source}"
end

desc 'removes callruby and .o files'
task 'clean' do
  rm_f %w[callruby main.o query-rb.o]
end
