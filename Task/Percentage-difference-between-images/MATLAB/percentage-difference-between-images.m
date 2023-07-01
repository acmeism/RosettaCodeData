% Percentage difference between images
function p = PercentageDifferenceBetweenImages(im1,im2)

if numel(im1)~=numel(im2),
    error('Error: images have to be the same size');
end

d = abs(single(im1) - single(im2))./255;
p = sum(d(:))./numel(im1)*100;

disp(['Percentage difference between images is: ', num2str(p), '%'])
