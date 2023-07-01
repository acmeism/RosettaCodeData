4.times{ puts "Example" }  # idiomatic way

def repeat(proc,num)
  num.times{ proc.call }
end

repeat(->{ puts "Example" }, 4)
