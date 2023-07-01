require "open-uri"
require "cgi"

tasks  = ["Greatest_common_divisor", "Greatest_element_of_a_list", "Greatest_subsequential_sum"]
part_uri  = "http://rosettacode.org/wiki?action=raw&title="
Report = Struct.new(:count, :tasks)
result = Hash.new{|h,k| h[k] = Report.new(0, [])}

tasks.each do |task|
  puts "processing #{task}"
  current_lang = "no language"
  open(part_uri + CGI.escape(task)).each_line do |line|
    current_lang = Regexp.last_match["lang"] if /==\{\{header\|(?<lang>.+)\}\}==/ =~ line
    num_no_langs = line.scan(/<lang\s*>/).size
    if num_no_langs > 0 then
      result[current_lang].count += num_no_langs
      result[current_lang].tasks << task
    end
  end
end

puts "\n#{result.values.map(&:count).inject(&:+)} bare language tags.\n\n"
result.each{|k,v| puts "#{v.count} in #{k} (#{v.tasks})"}
