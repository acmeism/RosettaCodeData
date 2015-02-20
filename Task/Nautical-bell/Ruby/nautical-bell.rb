watches = [ "First", "Middle", "Morning", "Forenoon", "Afternoon", "First dog", "Last dog", "First" ]
watch_ends = [ "00:00", "04:00", "08:00", "12:00", "16:00", "18:00", "20:00", "23:59" ]
words = ["One","Two","Three","Four","Five","Six","Seven","Eight"]
sound = "ding!"

loop do
  time = Time.now
  if time.sec == 0 and time.min % 30 == 0
    num = (time.hour * 60 + time.min) / 30 % 8
    num = 8 if num == 0
    hr_min = time.strftime "%H:%M"
    idx = watch_ends.find_index {|t| hr_min <= t}
    text = "%s - %s watch, %s bell%s gone" % [
        hr_min,
        watches[idx],
        words[num-1],
        num==1 ? "" : "s"
    ]
    bells = (sound * num).gsub(sound + sound) {|dd| dd + ' '}
    puts "%-45s %s" % [text, bells]
  end
  sleep 1
end
