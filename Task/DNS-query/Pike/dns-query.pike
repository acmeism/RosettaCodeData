> array ips = Protocols.DNS.gethostbyname("www.kame.net")[1] || ({});
> write(ips*"\n");
