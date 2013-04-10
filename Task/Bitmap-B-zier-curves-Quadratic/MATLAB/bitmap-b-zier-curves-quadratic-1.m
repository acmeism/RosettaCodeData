function bezierQuad(obj,pixel_0,pixel_1,pixel_2,color,varargin)

    if( isempty(varargin) )
        resolution = 20;
    else
        resolution = varargin{1};
    end

    %Calculate time axis
    time = (0:1/resolution:1)';
    timeMinus = 1-time;

    %The formula for the curve is expanded for clarity, the lack of
    %loops is because its calculation has been vectorized
    curve = (timeMinus.^2)*pixel_0; %First term of polynomial
    curve = curve + (2.*time.*timeMinus)*pixel_1; %second term of polynomial
    curve = curve + (time.^2)*pixel_2; %third term of polynomial

    curve = round(curve); %round each of the points to the nearest integer

    %connect each of the points in the curve with a line using the
    %Bresenham Line algorithm
    for i = (1:length(curve)-1)
        obj.bresenhamLine(curve(i,:),curve(i+1,:),color);
    end

    assignin('caller',inputname(1),obj); %saves the changes to the object

end
