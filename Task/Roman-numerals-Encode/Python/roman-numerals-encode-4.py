romanDgts= 'ivxlcdmVXLCDM_'

def ToRoman(num):
   namoR = ''
   if num >=4000000:
      print 'Too Big -'
      return '-----'
   for rdix in range(0, len(romanDgts), 2):
      if num==0: break
      num,r = divmod(num,10)
      v,r = divmod(r, 5)
      if r==4:
         namoR += romanDgts[rdix+1+v] + romanDgts[rdix]
      else:
         namoR += r*romanDgts[rdix] + (romanDgts[rdix+1] if(v==1) else '')
   return namoR[-1::-1]
