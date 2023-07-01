# raise (throw) an exception
def spam
  raise SillyError, 'egg'
end

# rescue (catch) an exception
begin
  spam
rescue SillyError => se
  puts se  # writes 'egg' to stdout
end
