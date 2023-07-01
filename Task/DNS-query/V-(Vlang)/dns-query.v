import net

fn main() {
	addr := 'www.kame.net:80'
	@type := net.SocketType.tcp
	family := net.AddrFamily.unspec
	mut addrs := []net.Addr{}
	mut results :=''

	addrs = net.resolve_addrs(addr, family, @type) or {println('Error: nothing resolved') exit(1)}
	for each in addrs {
		results += '${addr.split(':')[0]} * ${each} * ${each.family()} * ${@type} \n'
	}
	println(results)

}
