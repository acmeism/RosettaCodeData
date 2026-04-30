enum Justification
  Left
  Right
  Center
end

def align_columns (text, justification = Justification::Left)
  rows = text.lines.map(&.split('$'))

  field_sizes = (0...rows.max_of(&.size)).map {|idx|
    rows.max_of {|r| (r[idx]? || "").size }
  }
  rows.each do |row|
    puts row.zip(field_sizes).map {|field, size|
      case justification
      in Justification::Left   then field.ljust(size)
      in Justification::Right  then field.rjust(size)
      in Justification::Center then field.center(size)
      end
    }.join(' ')
  end
end

DSV = <<-EOT
  Given$a$text$file$of$many$lines,$where$fields$within$a$line$
  are$delineated$by$a$single$'dollar'$character,$write$a$program
  that$aligns$each$column$of$fields$by$ensuring$that$words$in$each$
  column$are$separated$by$at$least$one$space.
  Further,$allow$for$each$word$in$a$column$to$be$either$left$
  justified,$right$justified,$or$center$justified$within$its$column.
  EOT

Justification.values.each do |just|
  puts "#{just}:"
  align_columns DSV, just
  puts
end
