void printHostname() throws UnknownHostException {
    InetAddress localhost = InetAddress.getLocalHost();
    System.out.println(localhost.getHostName());
}
