width = input('Array Width: ');
height = input('Array Height: ');

array  = zeros(width,height);

array(1,1) = 12;

disp(['Array element (1,1) = ' num2str(array(1,1))]);

clear array;  % de-allocate (remove) array from workspace
