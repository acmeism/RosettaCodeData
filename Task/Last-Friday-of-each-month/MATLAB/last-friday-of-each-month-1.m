y = 2025
mprintf('last fridays in %u \n', y)
for m = 1:12
    mprintf('%02u.%02u.%4u\n', max(calendar(y,m)(3)(:,5)), m, y)
end
