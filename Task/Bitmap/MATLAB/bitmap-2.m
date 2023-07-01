>> img = Bitmap(20,30);
>> img.fill([30 30 150]);
>> img.setPixel([10 15],[20 130 66]);
>> disp(img)
>> img.getPixel([10 15])

ans =

   20  130   66

>> img.getPixel([10 15],'red')

ans =

   20

>> img.save()
Save Complete
