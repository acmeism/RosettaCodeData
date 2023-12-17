let mactable = http get "http://standards-oui.ieee.org/oui/oui.csv" | from csv --no-infer

def get-mac-org [] {
	let assignment = $in | str upcase | str replace --all --regex "[^A-Z0-9]" "" | str substring 0..6
	$mactable | where Assignment == $assignment | try {first | get "Organization Name"} catch {"N/A"}
}

# Test cases from the Ada entry
let macs = [
	# Should succeed
	"88:53:2E:67:07:BE"
	"D4:F4:6F:C9:EF:8D"
	"FC:FB:FB:01:FA:21"
	"4c:72:b9:56:fe:bc"
	"00-14-22-01-23-45"
	# Should fail
	"23-45-67"
	"foobar"
]

$macs | each {{MAC: $in, Vendor: ($in | get-mac-org)}}
