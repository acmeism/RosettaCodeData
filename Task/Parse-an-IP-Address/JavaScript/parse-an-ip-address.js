// IP Address Parser in JavaScript
class ParseIPAddress {
    constructor() {
        this.IPV4_PAT = /^(\d+)\.(\d+)\.(\d+)\.(\d+)(?::(\d+))?$/;
        this.IPV6_DOUBL_COL_PAT = /^\[?([0-9a-f:]*)::([0-9a-f:]*)(?:\]:(\d+))?$/;

        // Build IPv6 pattern dynamically
        let ipv6Pattern = "^\\[?";
        for (let i = 1; i <= 7; i++) {
            ipv6Pattern += "([0-9a-f]+):";
        }
        ipv6Pattern += "([0-9a-f]+)(?:\\]:(\\d+))?$";
        this.IPV6_PAT = new RegExp(ipv6Pattern);
    }

    static main() {
        const tests = [
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
        ];

        const parser = new ParseIPAddress();

        console.log(`${"Test Case".padEnd(40)} ${"Hex Address".padEnd(32)}   Port`);

        for (const ip of tests) {
            try {
                const parsed = parser.parseIP(ip);
                console.log(`${ip.padEnd(40)} ${parsed[0].padEnd(32)}   ${parsed[1]}`);
            } catch (e) {
                console.log(`${ip.padEnd(40)} Invalid address:  ${e.message}`);
            }
        }
    }

    parseIP(ip) {
        let hex = "";
        let port = "";

        // IPv4
        const ipv4Match = ip.match(this.IPV4_PAT);
        if (ipv4Match) {
            for (let i = 1; i <= 4; i++) {
                hex += this.toHex4(ipv4Match[i]);
            }
            if (ipv4Match[5] !== undefined) {
                port = ipv4Match[5];
            }
            return [hex, port];
        }

        // IPv6, double colon
        const ipv6DoubleColonMatch = ip.match(this.IPV6_DOUBL_COL_PAT);
        if (ipv6DoubleColonMatch) {
            let p1 = ipv6DoubleColonMatch[1];
            if (p1 === "") {
                p1 = "0";
            }
            let p2 = ipv6DoubleColonMatch[2];
            if (p2 === "") {
                p2 = "0";
            }
            ip = p1 + this.getZero(8 - this.numCount(p1) - this.numCount(p2)) + p2;
            if (ipv6DoubleColonMatch[3] !== undefined) {
                ip = "[" + ip + "]:" + ipv6DoubleColonMatch[3];
            }
        }

        // IPv6
        const ipv6Match = ip.match(this.IPV6_PAT);
        if (ipv6Match) {
            for (let i = 1; i <= 8; i++) {
                hex += this.toHex6(ipv6Match[i]).padStart(4, "0");
            }
            if (ipv6Match[9] !== undefined) {
                port = ipv6Match[9];
            }
            return [hex, port];
        }

        throw new Error("ERROR 103: Unknown address: " + ip);
    }

    numCount(s) {
        return s.split(":").length;
    }

    getZero(count) {
        let result = ":";
        while (count > 0) {
            result += "0:";
            count--;
        }
        return result;
    }

    toHex4(s) {
        const val = parseInt(s, 10);
        if (val < 0 || val > 255) {
            throw new Error("ERROR 101: Invalid value : " + s);
        }
        return val.toString(16).padStart(2, "0");
    }

    toHex6(s) {
        const val = parseInt(s, 16);
        if (val < 0 || val > 65536) {
            throw new Error("ERROR 102: Invalid hex value : " + s);
        }
        return s;
    }
}

// Run the main function
ParseIPAddress.main();
