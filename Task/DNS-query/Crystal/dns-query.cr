require "socket"

Socket::Addrinfo.resolve(
	"www.kame.net",
	80,
	type: Socket::Type::STREAM
).each { |a|
	puts a.ip_address.address
}
