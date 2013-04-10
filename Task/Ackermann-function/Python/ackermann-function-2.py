def ack2(M, N):
    if M == 0:
        return N + 1
    elif N == 0:
        return ack1(M - 1, 1)
    else:
        return ack1(M - 1, ack1(M, N - 1))
