exit if RUBY_VERSION < '1.8.6'
  puts bloop.abs if defined?(bloop) and bloop.respond_to?(:abs)
