require 'time'
d = "March 7 2009 7:30pm EST"
t = Time.parse(d)
puts t.rfc2822
puts t.zone

new = t + 12*3600
puts new.rfc2822
puts new.zone

# another timezone
require 'rubygems'
require 'active_support'
zone = ActiveSupport::TimeZone['Beijing']
remote = zone.at(new)
# or, remote = new.in_time_zone('Beijing')
puts remote.rfc2822
puts remote.zone
