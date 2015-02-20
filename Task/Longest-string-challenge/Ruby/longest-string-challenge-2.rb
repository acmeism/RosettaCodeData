puts open("test.txt").each_line.group_by(&:size).max.last
