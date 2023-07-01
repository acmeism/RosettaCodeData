public let CSI = ESC+"["   // Control Sequence Introducer
func write(_ text: String...) {
  for txt in text { write(STDOUT_FILENO, txt, txt.utf8.count) }
}
write(CSI,"?1049h") // open alternate screen
print("Alternate screen buffer\n")
for n in (1...5).reversed() {
    print("Going back in \(n)...")
    sleep(1)
}
write(CSI,"?1049l") // close alternate screen
