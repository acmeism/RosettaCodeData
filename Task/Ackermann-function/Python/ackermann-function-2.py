def ack2(M, N):
    if M == 0:
        return N + 1
    elif N == 0:
        return ack2(M - 1, 1)
    else:
        return ack2(M - 1, ack2(M, N - 1))
