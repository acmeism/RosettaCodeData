#!/usr/bin/python
# -*- coding: utf-8 -*-

import spread

PORT = '4803'

# connect spread daemon
conn = spread.connect(PORT)
# join the room
conn.join('test')

print 'Waiting for messages... If you want to stop this script, please stop spread daemon'
while True:
    recv = conn.receive()
    if hasattr(recv, 'sender') and hasattr(recv, 'message'):
        print 'Sender: %s' % recv.sender
        print 'Message: %s' % recv.message
