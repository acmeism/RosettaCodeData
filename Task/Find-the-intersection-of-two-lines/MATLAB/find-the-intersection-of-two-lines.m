function cross=intersection(line1,line2)
    a=polyfit(line1(:,1),line1(:,2),1);
    b=polyfit(line2(:,1),line2(:,2),1);
    cross=[a(1) -1; b(1) -1]\[-a(2);-b(2)];
end
