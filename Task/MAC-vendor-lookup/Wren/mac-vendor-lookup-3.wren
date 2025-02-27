import "os" for Process
import "timer" for Timer

var macs = ["88:53:2E:67:07:BE", "FC:FB:FB:01:FA:21", "D4:F4:6F:C9:EF:8D", "23:45:67"]
for (mac in macs) {
    var vendor = Process.read("curl -s " + "https://api.macvendors.com/" + mac)
    if (vendor.contains("errors")) vendor = "Vendor not found"
    System.print("%(mac)  %(vendor)")
    Timer.wait(2000)
}
