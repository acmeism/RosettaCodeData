# store this in file rc_embed.py
# store this in file rc_embed.py
def query(buffer_length):
    message = b'Here am I'
    L = len(message)
    return message[0:L*(L <= buffer_length)]
