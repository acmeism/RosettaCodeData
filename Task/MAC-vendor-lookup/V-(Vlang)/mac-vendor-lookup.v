import net.http
import time

const macs =
('
FC-A1-3E
FC:FB:FB:01:FA:21
D4:F4:6F:C9:EF:8D
')

fn main() {
    for line in macs.split('\n') {
        if line !='' {
            println(mac_lookup(line))
            time.sleep(2 * time.second) // considerate delay between attempts
        }
    }
}

fn mac_lookup(mac string) string {
    resp := http.get("http://api.macvendors.com/" + mac) or {return 'No data from server'}
    return resp.body.str()
}
