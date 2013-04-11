>> subject = [[50;200;350;350;250;200;150;100;100],[150;50;150;300;300;250;350;250;200]];
>> clipPolygon = [[100;300;300;100],[100;100;300;300]];
>> clippedSubject = sutherlandHodgman(subject,clipPolygon);
>> plot([subject(:,1);subject(1,1)],[subject(:,2);subject(1,2)],'blue')
>> hold on
>> plot([clipPolygon(:,1);clipPolygon(1,1)],[clipPolygon(:,2);clipPolygon(1,2)],'r')
>> patch(clippedSubject(:,1),clippedSubject(:,2),0);
>> axis square
