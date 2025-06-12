class Array
  def sort_with_prompt
    rels = { "<" => -1, "=" => 0, ">" => 1 }
    n = 0
    puts "Answer with <, = or >"
    sort {|a, b|
      n += 1
      loop do
        print "#{n})  #{a} < = > #{b} ?: "
        ans = gets
        break rels[ans] if ans.in?(rels.keys)
      end
    }
  end
end

p %w(violet red green indigo blue yellow orange).sort_with_prompt
