use std::net::Ipv4Addr;

fn canonical_cidr(cidr: &str) -> Result<String, &str> {
    let mut split = cidr.splitn(2, '/');
    if let (Some(addr), Some(mask)) = (split.next(), split.next()) {
        let addr = addr.parse::<Ipv4Addr>().map(u32::from).map_err(|_| cidr)?;
        let mask = mask.parse::<u8>().map_err(|_| cidr)?;
        let bitmask = 0xff_ff_ff_ffu32 << (32 - mask);
        let addr = Ipv4Addr::from(addr & bitmask);
        Ok(format!("{}/{}", addr, mask))
    } else {
        Err(cidr)
    }
}

#[cfg(test)]
mod tests {

    #[test]
    fn valid() {
        [
            ("87.70.141.1/22", "87.70.140.0/22"),
            ("36.18.154.103/12", "36.16.0.0/12"),
            ("62.62.197.11/29", "62.62.197.8/29"),
            ("67.137.119.181/4", "64.0.0.0/4"),
            ("161.214.74.21/24", "161.214.74.0/24"),
            ("184.232.176.184/18", "184.232.128.0/18"),
        ]
        .iter()
        .cloned()
        .for_each(|(input, expected)| {
            assert_eq!(expected, super::canonical_cidr(input).unwrap());
        });
    }
}

fn main() {
    println!("{}", canonical_cidr("127.1.2.3/24").unwrap());
}
