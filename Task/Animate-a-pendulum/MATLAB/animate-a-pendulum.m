%This is a numerical simulation of a pendulum with a massless pivot arm.

%% User Defined Parameters
%Define external parameters
g = -9.8;
deltaTime = 1/50; %Decreasing this will increase simulation accuracy
endTime = 16;

%Define pendulum
rodPivotPoint = [2 2]; %rectangular coordinates
rodLength = 1;
mass = 1; %of the bob
radius = .2; %of the bob
theta = 45; %degrees, defines initial position of the bob
velocity = [0 0]; %cylindrical coordinates; first entry is radial velocity,
                  %second entry is angular velocity

%% Simulation
assert(radius < rodLength,'Pendulum bob radius must be less than the length of the rod.');

position = rodPivotPoint - (rodLength*[-sind(theta) cosd(theta)]); %in rectangular coordinates

%Generate graphics, render pendulum
figure;
axesHandle = gca;
xlim(axesHandle, [(rodPivotPoint(1) - rodLength - radius) (rodPivotPoint(1) + rodLength + radius)] );
ylim(axesHandle, [(rodPivotPoint(2) - rodLength - radius) (rodPivotPoint(2) + rodLength + radius)] );

rectHandle = rectangle('Position',[(position - radius/2) radius radius],...
    'Curvature',[1,1],'FaceColor','g'); %Pendulum bob
hold on
plot(rodPivotPoint(1),rodPivotPoint(2),'^'); %pendulum pivot
lineHandle = line([rodPivotPoint(1) position(1)],...
    [rodPivotPoint(2) position(2)]); %pendulum rod
hold off

%Run simulation, all calculations are performed in cylindrical coordinates
for time = (deltaTime:deltaTime:endTime)

    drawnow; %Forces MATLAB to render the pendulum

    %Find total force
    gravitationalForceCylindrical = [mass*g*cosd(theta) mass*g*sind(theta)];

    %This code is just incase you want to add more forces,e.g friction
    totalForce = gravitationalForceCylindrical;

    %If the rod isn't massless or is a spring, etc., modify this line
    %accordingly
    rodForce = [-totalForce(1) 0]; %cylindrical coordinates

    totalForce = totalForce + rodForce;

    acceleration = totalForce / mass; %F = ma
    velocity = velocity + acceleration * deltaTime;
    rodLength = rodLength + velocity(1) * deltaTime;
    theta = theta + velocity(2) * deltaTime; % Attention!! Mistake here.
    % Velocity needs to be divided by pendulum length and scaled to degrees:
    % theta = theta + velocity(2) * deltaTime/rodLength/pi*180;

    position = rodPivotPoint - (rodLength*[-sind(theta) cosd(theta)]);

    %Update figure with new position info
    set(rectHandle,'Position',[(position - radius/2) radius radius]);
    set(lineHandle,'XData',[rodPivotPoint(1) position(1)],'YData',...
        [rodPivotPoint(2) position(2)]);

end
