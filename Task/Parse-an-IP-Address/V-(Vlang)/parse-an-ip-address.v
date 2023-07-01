const data =
('
127.0.0.1
127.0.0.1:80
::1
[::1]:80
2605:2700:0:3::4713:93e3
[2605:2700:0:3::4713:93e3]:80
')

fn main() {
    mut output :=''
    for val in data.split('\n') {
        if val !='' {
            xarr := parse_ip(val)
            output += 'input = ' + val + '\t>\t' + xarr[0] + if xarr[1] !='' {' port : ' + xarr[1]} else {''} + '\n'
        }
    }
    println(output)
}

fn parse_ip(address string) []string {
    return if address.contains('.') {ipv4(address)} else {ipv6(address)}
}

fn ipv4(address string) []string {
    mut num, mut port := '', ''
    for val in address.split('.') {
        xarr := val.split(':')
        num += xarr[0].int().hex2().replace('x','')
        if xarr.len > 1 {port = xarr[1]} else {port =''}
    }
    return [num, port]
}

fn ipv6(address string) []string {
    mut num, mut port := '', ''
    for idx, val in address.split(']') {
        if idx == 0 {
            for xal in val.trim_left('[:').split(':') {
                if xal =='' {num += '00000000'} else {num += '0000'.substr(0, 4 - xal.len) + xal}
            }
        }
        else {port = val.trim_left(':')}
    }
    return ['00000000000000000000000000000000'.substr(0, 32 - num.len) + num, port]
}
