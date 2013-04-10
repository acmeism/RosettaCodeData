#!/usr/bin/python
# -*- coding: utf-8 -*-

import spread

PORT = '4803'

conn = spread.connect(PORT)
conn.join('test')

conn.multicast(spread.RELIABLE_MESS, 'test', 'hello, this is message sent from python')
conn.disconnect()
