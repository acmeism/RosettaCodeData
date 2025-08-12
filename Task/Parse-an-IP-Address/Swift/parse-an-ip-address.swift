import Foundation

struct IPParseResult {
    let hexAddress: String
    let port: String
}

enum IPParseError: Error {
    case invalidValue(String)
    case invalidHexValue(String)
    case unknownAddress(String)

    var localizedDescription: String {
        switch self {
        case .invalidValue(let value):
            return "ERROR 101: Invalid value: \(value)"
        case .invalidHexValue(let value):
            return "ERROR 102: Invalid hex value: \(value)"
        case .unknownAddress(let address):
            return "ERROR 103: Unknown address: \(address)"
        }
    }
}

class ParseIPAddress {

    // IPv4 pattern: matches IP with optional port
    private static let ipv4Pattern = #"^(\d+)\.(\d+)\.(\d+)\.(\d+)(?::(\d+))?$"#

    // IPv6 double colon pattern: matches compressed IPv6 with optional port
    private static let ipv6DoubleColonPattern = #"^\[?([0-9a-f:]*)::([0-9a-f:]*)(?:\]:(\d+))?$"#

    // IPv6 full pattern: dynamically built for full IPv6 addresses
    private static let ipv6Pattern: String = {
        var pattern = #"^\[?"#
        for i in 1...7 {
            pattern += #"([0-9a-f]+):"#
        }
        pattern += #"([0-9a-f]+)(?:\]:(\d+))?$"#
        return pattern
    }()

    static func main() {
        let tests = [
            "192.168.0.1",
            "127.0.0.1",
            "256.0.0.1",
            "127.0.0.1:80",
            "::1",
            "[::1]:80",
            "[32e::12f]:80",
            "2605:2700:0:3::4713:93e3",
            "[2605:2700:0:3::4713:93e3]:80",
            "2001:db8:85a3:0:0:8a2e:370:7334"
        ]

        // Print header with proper padding
        let header = "Test Case".padding(toLength: 40, withPad: " ", startingAt: 0) +
                    "Hex Address".padding(toLength: 32, withPad: " ", startingAt: 0) +
                    "   Port"
        print(header)

        for ip in tests {
            do {
                let result = try parseIP(ip)
                let output = ip.padding(toLength: 40, withPad: " ", startingAt: 0) +
                           result.hexAddress.padding(toLength: 32, withPad: " ", startingAt: 0) +
                           "   " + result.port
                print(output)
            } catch {
                let output = ip.padding(toLength: 40, withPad: " ", startingAt: 0) +
                           "Invalid address: " + error.localizedDescription
                print(output)
            }
        }
    }

    private static func parseIP(_ ip: String) throws -> IPParseResult {
        var hex = ""
        var port = ""

        // Try IPv4 first
        if let ipv4Regex = try? NSRegularExpression(pattern: ipv4Pattern, options: [.caseInsensitive]) {
            let range = NSRange(location: 0, length: ip.utf16.count)
            if let match = ipv4Regex.firstMatch(in: ip, options: [], range: range) {
                // Extract the 4 octets
                for i in 1...4 {
                    let groupRange = match.range(at: i)
                    let octet = String(ip[Range(groupRange, in: ip)!])
                    hex += try toHex4(octet)
                }

                // Check for port
                let portRange = match.range(at: 5)
                if portRange.location != NSNotFound {
                    port = String(ip[Range(portRange, in: ip)!])
                }

                return IPParseResult(hexAddress: hex, port: port)
            }
        }

        var modifiedIP = ip

        // Try IPv6 with double colon
        if let ipv6DoubleColonRegex = try? NSRegularExpression(pattern: ipv6DoubleColonPattern, options: [.caseInsensitive]) {
            let range = NSRange(location: 0, length: ip.utf16.count)
            if let match = ipv6DoubleColonRegex.firstMatch(in: ip, options: [], range: range) {
                let p1Range = match.range(at: 1)
                let p2Range = match.range(at: 2)
                let portRange = match.range(at: 3)

                var p1 = p1Range.location != NSNotFound ? String(ip[Range(p1Range, in: ip)!]) : ""
                var p2 = p2Range.location != NSNotFound ? String(ip[Range(p2Range, in: ip)!]) : ""

                if p1.isEmpty {
                    p1 = "0"
                }
                if p2.isEmpty {
                    p2 = "0"
                }

                let zeroCount = 8 - numCount(p1) - numCount(p2)
                modifiedIP = p1 + getZero(zeroCount) + p2

                if portRange.location != NSNotFound {
                    let portStr = String(ip[Range(portRange, in: ip)!])
                    modifiedIP = "[\(modifiedIP)]:\(portStr)"
                }
            }
        }

        // Try full IPv6
        if let ipv6Regex = try? NSRegularExpression(pattern: ipv6Pattern, options: [.caseInsensitive]) {
            let range = NSRange(location: 0, length: modifiedIP.utf16.count)
            if let match = ipv6Regex.firstMatch(in: modifiedIP, options: [], range: range) {
                // Extract the 8 groups
                for i in 1...8 {
                    let groupRange = match.range(at: i)
                    let group = String(modifiedIP[Range(groupRange, in: modifiedIP)!])
                    let hexGroup = try toHex6(group)
                    let paddedHex = hexGroup.padding(toLength: 4, withPad: "0", startingAt: 0)
                    hex += paddedHex
                }

                // Check for port
                let portRange = match.range(at: 9)
                if portRange.location != NSNotFound {
                    port = String(modifiedIP[Range(portRange, in: modifiedIP)!])
                }

                return IPParseResult(hexAddress: hex, port: port)
            }
        }

        throw IPParseError.unknownAddress(ip)
    }

    private static func numCount(_ s: String) -> Int {
        return s.components(separatedBy: ":").count
    }

    private static func getZero(_ count: Int) -> String {
        var result = ":"
        for _ in 0..<count {
            result += "0:"
        }
        return result
    }

    private static func toHex4(_ s: String) throws -> String {
        guard let val = Int(s), val >= 0 && val <= 255 else {
            throw IPParseError.invalidValue(s)
        }
        return String(format: "%02x", val)
    }

    private static func toHex6(_ s: String) throws -> String {
        guard let val = Int(s, radix: 16), val >= 0 && val <= 65535 else {
            throw IPParseError.invalidHexValue(s)
        }
        return s
    }
}

// Run the program
ParseIPAddress.main()
