"""Connect to a socket. Requires Python >= 3.2."""
import socket

with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as sock:
    sock.connect(("localhost", 256))
    sock.sendall(b"hello socket world")
