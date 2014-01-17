module Main where

import Network.Socket

getWebAddresses :: HostName -> IO [SockAddr]
getWebAddresses host = do
  results <- getAddrInfo (Just defaultHints) (Just host) (Just "http")
  return [ addrAddress a | a <- results, addrSocketType a == Stream ]

showIPs :: HostName -> IO ()
showIPs host = do
  putStrLn $ "IP addresses for " ++ host ++ ":"
  addresses <- getWebAddresses host
  mapM_ (putStrLn . ("  "++) . show) addresses

main = showIPs "www.kame.net"
