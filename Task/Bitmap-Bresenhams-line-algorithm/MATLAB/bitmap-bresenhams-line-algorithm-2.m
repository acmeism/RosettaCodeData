>> img = Bitmap(800,600);
>> img.bresenhamLine([400 550],[200 400],[255 255 255]);
>> img.bresenhamLine([400 550],[600 400],[255 255 255]);
>> img.bresenhamLine([200 400],[350 150],[255 255 255]);
>> img.bresenhamLine([600 400],[450 150],[255 255 255]);
>> img.bresenhamLine([350 150],[450 150],[255 255 255]);
>> img.bresenhamLine([400 550],[400 150],[255 255 255]);
>> disp(img)
