import static java.lang.Math.*

final format = 'HH:mm:ss',  clock = PI / 12,  millisPerHr = 3600*1000
final tzOffset = new Date(0).timezoneOffset / 60
def parseTime = { time -> (Date.parse(format, time).time / millisPerHr) - tzOffset }
def formatTime = { time -> new Date((time + tzOffset) * millisPerHr as int).format(format) }
def mean = { list, closure -> list.sum(closure)/list.size() }
def meanTime = { ... timeStrings ->
    def times = timeStrings.collect(parseTime)
    formatTime(atan2( mean(times) { sin(it * clock) }, mean(times) { cos(it * clock) }) / clock)
}
