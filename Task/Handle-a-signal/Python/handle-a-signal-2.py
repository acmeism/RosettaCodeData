import time

def intrptWIN():
   procDone = False
   n = 0

   while not procDone:
      try:
         time.sleep(0.5)
         n += 1
         print n
      except KeyboardInterrupt, e:
         procDone = True

t1 = time.time()
intrptWIN()
tdelt = time.time() - t1
print 'Program has run for %5.3f seconds.' % tdelt
