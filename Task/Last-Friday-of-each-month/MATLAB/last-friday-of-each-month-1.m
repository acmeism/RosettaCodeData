y = 2025
mprintf('last fridays of each month in %u: \n', y)
for m = 1:12
    mprintf('%02u/%02u/%4u\n', m, max(calendar(y,m)(3)(:,5)), y)
end
