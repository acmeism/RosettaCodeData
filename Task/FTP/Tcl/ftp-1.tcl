package require ftp

set conn [::ftp::Open kernel.org anonymous "" -mode passive]
::ftp::Cd $conn /pub/linux/kernel
foreach line [ftp::NList $conn] {
    puts $line
}
::ftp::Type $conn binary
::ftp::Get $conn README README
