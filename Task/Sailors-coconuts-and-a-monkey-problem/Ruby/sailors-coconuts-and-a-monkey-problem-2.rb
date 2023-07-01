def coconuts(sailor)
  sailor.step(by:sailor) do |nuts|
    flag = sailor.times do
      break if nuts % (sailor-1) != 0
      nuts += nuts / (sailor-1) + 1
    end
    return nuts if flag
  end
end

(2..9).each do |sailor|
  puts "#{sailor}: #{coconuts(sailor)}"
end
