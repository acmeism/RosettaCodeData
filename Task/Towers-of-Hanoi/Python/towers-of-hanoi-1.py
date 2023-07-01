def hanoi(ndisks, startPeg=1, endPeg=3):
    if ndisks:
        hanoi(ndisks-1, startPeg, 6-startPeg-endPeg)
        print(f"Move disk {ndisks} from peg {startPeg} to peg {endPeg}")
        hanoi(ndisks-1, 6-startPeg-endPeg, endPeg)

hanoi(4)
