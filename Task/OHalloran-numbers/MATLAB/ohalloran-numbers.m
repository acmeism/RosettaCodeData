max_area = 1000;
half_max = max_area / 2;
areas = ones(1, max_area); % Initialize areas with 1's

for i = 1:max_area
    for j = 1:half_max
        if (i * j > half_max)
            break;
        endif
        for k = 1:half_max
            area = 2 * (i * j + i * k + j * k);
            if (area > max_area)
                break;
            endif
            areas(area) = 0; % Mark as not an O'Halloran number
        endfor
    endfor
endfor

% Print the O'Halloran numbers
printf("Even surface areas < NOT %d achievable by any regular integer-valued cuboid:\n", max_area);
for n = 1:max_area/2
    if (areas(2*n))
        printf("%d ", 2*n);
    endif
endfor
printf("\n");
