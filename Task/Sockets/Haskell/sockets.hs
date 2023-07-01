import Network

main = withSocketsDo $ sendTo "localhost" (PortNumber $ toEnum 256) "hello socket world"
