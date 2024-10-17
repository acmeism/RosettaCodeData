use std::{error::Error, fs::File, io::copy};
use ftp::FtpStream;

fn main() -> Result<(), Box<dyn Error>> {
    let mut ftp = FtpStream::connect("ftp.easynet.fr:21")?;
    ftp.login("anonymous", "")?;
    ftp.cwd("debian")?;
    for file in ftp.list(None)? {
        println!("{}", file);
    }
    let mut stream = ftp.get("README")?;
    let mut file = File::create("README")?;
    copy(&mut stream, &mut file)?;
    Ok(())
}
