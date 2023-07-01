function trigExample(angleDegrees)

    angleRadians = angleDegrees * (pi/180);

    disp(sprintf('sin(%f)= %f\nasin(%f)= %f',[angleRadians sin(angleRadians) sin(angleRadians) asin(sin(angleRadians))]));
    disp(sprintf('sind(%f)= %f\narcsind(%f)= %f',[angleDegrees sind(angleDegrees) sind(angleDegrees) asind(sind(angleDegrees))]));
    disp('-----------------------');
    disp(sprintf('cos(%f)= %f\nacos(%f)= %f',[angleRadians cos(angleRadians) cos(angleRadians) acos(cos(angleRadians))]));
    disp(sprintf('cosd(%f)= %f\narccosd(%f)= %f',[angleDegrees cosd(angleDegrees) cosd(angleDegrees) acosd(cosd(angleDegrees))]));
    disp('-----------------------');
    disp(sprintf('tan(%f)= %f\natan(%f)= %f',[angleRadians tan(angleRadians) tan(angleRadians) atan(tan(angleRadians))]));
    disp(sprintf('tand(%f)= %f\narctand(%f)= %f',[angleDegrees tand(angleDegrees) tand(angleDegrees) atand(tand(angleDegrees))]));
end
