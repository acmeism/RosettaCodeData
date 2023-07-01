use std::{
    net::{IpAddr, SocketAddr},
    str::FromStr,
};

#[derive(Clone, Debug)]
struct Addr {
    addr: IpAddr,
    port: Option<u16>,
}

impl std::fmt::Display for Addr {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        let ipv = if self.addr.is_ipv4() { "4" } else { "6" };

        let hex = match self.addr {
            IpAddr::V4(addr) => u32::from(addr) as u128,
            IpAddr::V6(addr) => u128::from(addr),
        };

        match self.port {
            Some(p) => write!(
                f,
                "address: {}, port: {}, hex: {:x} (IPv{})",
                self.addr, p, hex, ipv
            ),

            None => write!(
                f,
                "address: {}, port: N/A, hex: {:x} (IPv{}) ",
                self.addr, hex, ipv
            ),
        }
    }
}

impl FromStr for Addr {
    type Err = ();

    fn from_str(s: &str) -> Result<Self, Self::Err> {
        if let Ok(addr) = s.parse::<IpAddr>() {
            Ok(Self { addr, port: None })
        } else if let Ok(sock) = s.parse::<SocketAddr>() {
            Ok(Self {
                addr: sock.ip(),
                port: Some(sock.port()),
            })
        } else {
            Err(())
        }
    }
}

fn print_addr(s: &str) {
    match s.parse::<Addr>() {
        Ok(addr) => println!("{}: {}", s, addr),
        _ => println!("{} not a valid address", s),
    }
}

fn main() {
    [
        "127.0.0.1",
        "127.0.0.1:80",
        "::1",
        "[::1]:80",
        "2605:2700:0:3::4713:93e3",
        "[2605:2700:0:3::4713:93e3]:80",
    ]
    .iter()
    .cloned()
    .for_each(print_addr);
}
