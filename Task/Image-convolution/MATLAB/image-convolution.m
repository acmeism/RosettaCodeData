function testConvImage
    Im = [1 2 1 5 5 ; ...
          1 2 7 9 9 ; ...
          5 5 5 5 5 ; ...
          5 2 2 2 2 ; ...
          1 1 1 1 1 ];      % Sample image for example illustration only
    Ker = [1 2 1 ; ...
           2 4 2 ; ...
           1 2 1 ];         % Gaussian smoothing (without normalizing)
    fprintf('Original image:\n')
    disp(Im)
    fprintf('Original kernel:\n')
    disp(Ker)
    fprintf('Padding with zeroes:\n')
    disp(convImage(Im, Ker, 'zeros'))
    fprintf('Padding with fives:\n')
    disp(convImage(Im, Ker, 'value', 5))
    fprintf('Duplicating border pixels to pad image:\n')
    disp(convImage(Im, Ker, 'extend'))
    fprintf('Renormalizing kernel and using only values within image:\n')
    disp(convImage(Im, Ker, 'partial'))
    fprintf('Only processing inner (non-border) pixels:\n')
    disp(convImage(Im, Ker, 'none'))
%     Ker = [1 2 1 ; ...
%            2 4 2 ; ...
%            1 2 1 ]./16;
%     Im = imread('testConvImageTestImage.png', 'png');
%     figure
%     imshow(imresize(Im, 10))
%     title('Original image')
%     figure
%     imshow(imresize(convImage(Im, Ker, 'zeros'), 10))
%     title('Padding with zeroes')
%     figure
%     imshow(imresize(convImage(Im, Ker, 'value', 50), 10))
%     title('Padding with fifty: 50')
%     figure
%     imshow(imresize(convImage(Im, Ker, 'extend'), 10))
%     title('Duplicating border pixels to pad image')
%     figure
%     imshow(imresize(convImage(Im, Ker, 'partial'), 10))
%     title('Renormalizing kernel and using only values within image')
%     figure
%     imshow(imresize(convImage(Im, Ker, 'none'), 10))
%     title('Only processing inner (non-border) pixels')
end

function ImOut = convImage(Im, Ker, varargin)
% ImOut = convImage(Im, Ker)
%   Filters an image using sliding-window kernel convolution.
%   Convolution is done layer-by-layer. Use rgb2gray if single-layer needed.
%   Zero-padding convolution will be used if no border handling is specified.
%   Im - Array containing image data (output from imread)
%   Ker - 2-D array to convolve image, needs odd number of rows and columns
%   ImOut - Filtered image, same dimensions and datatype as Im
%
% ImOut = convImage(Im, Ker, 'zeros')
%   Image will be padded with zeros when calculating convolution
%   (useful for magnitude calculations).
%
% ImOut = convImage(Im, Ker, 'value', padVal)
%   Image will be padded with padVal when calculating convolution
%   (possibly useful for emphasizing certain data with unusual kernel)
%
% ImOut = convImage(Im, Ker, 'extend')
%   Image will be padded with the value of the closest image pixel
%   (useful for smoothing or blurring filters).
%
% ImOut = convImage(Im, Ker, 'partial')
%   Image will not be padded. Borders will be convoluted with only valid pixels,
%   and convolution matrix will be renormalized counting only the pixels within
%   the image (also useful for smoothing or blurring filters).
%
% ImOut = convImage(Im, Ker, 'none')
%   Image will not be padded. Convolution will only be applied to inner pixels
%   (useful for edge and corner detection filters)

    % Handle input
    if mod(size(Ker, 1), 2) ~= 1 || mod(size(Ker, 2), 2) ~= 1
        eid = sprintf('%s:evenRowsCols', mfilename);
        error(eid,'''Ker'' parameter must have odd number of rows and columns.')
    elseif nargin > 4
        eid = sprintf('%s:maxrhs', mfilename);
        error(eid, 'Too many input arguments.');
    elseif nargin == 4 && ~strcmp(varargin{1}, 'value')
        eid = sprintf('%s:invalidParameterCombination', mfilename);
        error(eid, ['The ''padVal'' parameter is only valid with the ' ...
            '''value'' option.'])
    elseif nargin < 4 && strcmp(varargin{1}, 'value')
        eid = sprintf('%s:minrhs', mfilename);
        error(eid, 'Not enough input arguments.')
    elseif nargin < 3
        method = 'zeros';
    else
        method = lower(varargin{1});
        if ~any(strcmp(method, {'zeros' 'value' 'extend' 'partial' 'none'}))
            eid = sprintf('%s:invalidParameter', mfilename);
            error(eid, 'Invalid option parameter. Must be one of:%s', ...
                sprintf('\n\t\t%s', ...
                'zeros', 'value', 'extend', 'partial', 'none'))
        end
    end

    % Gather information and prepare for convolution
    [nImRows, nImCols, nImLayers] = size(Im);
    classIm = class(Im);
    Im = double(Im);
    ImOut = zeros(nImRows, nImCols, nImLayers);
    [nKerRows, nKerCols] = size(Ker);
    nPadRows = nImRows+nKerRows-1;
    nPadCols = nImCols+nKerCols-1;
    padH = (nKerRows-1)/2;
    padW = (nKerCols-1)/2;

    % Convolute on a layer-by-layer basis
    for k = 1:nImLayers
        if strcmp(method, 'zeros')
            ImOut(:, :, k) = conv2(Im(:, :, k), Ker, 'same');
        elseif strcmp(method, 'value')
            padding = varargin{2}.*ones(nPadRows, nPadCols);
            padding(padH+1:end-padH, padW+1:end-padW) = Im(:, :, k);
            ImOut(:, :, k) = conv2(padding, Ker, 'valid');
        elseif strcmp(method, 'extend')
            padding = zeros(nPadRows, nPadCols);
            padding(padH+1:end-padH, padW+1:end-padW) = Im(:, :, k);  % Middle
            padding(1:padH, 1:padW) = Im(1, 1, k);                    % TopLeft
            padding(end-padH+1:end, 1:padW) = Im(end, 1, k);          % BotLeft
            padding(1:padH, end-padW+1:end) = Im(1, end, k);          % TopRight
            padding(end-padH+1:end, end-padW+1:end) = Im(end, end, k);% BotRight
            padding(padH+1:end-padH, 1:padW) = ...
                repmat(Im(:, 1, k), 1, padW);                         % Left
            padding(padH+1:end-padH, end-padW+1:end) = ...
                repmat(Im(:, end, k), 1, padW);                       % Right
            padding(1:padH, padW+1:end-padW) = ...
                repmat(Im(1, :, k), padH, 1);                         % Top
            padding(end-padH+1:end, padW+1:end-padW) = ...
                repmat(Im(end, :, k), padH, 1);                       % Bottom
            ImOut(:, :, k) = conv2(padding, Ker, 'valid');
        elseif strcmp(method, 'partial')
            ImOut(padH+1:end-padH, padW+1:end-padW, k) = ...
                conv2(Im(:, :, k), Ker, 'valid');                     % Middle
            unprocessed = true(nImRows, nImCols);
            unprocessed(padH+1:end-padH, padW+1:end-padW) = false;    % Border
            for r = 1:nImRows
                for c = 1:nImCols
                    if unprocessed(r, c)
                        limitedIm = Im(max(1, r-padH):min(nImRows, r+padH), ...
                            max(1, c-padW):min(nImCols, c+padW), k);
                        limitedKer = Ker(max(1, 2-r+padH): ...
                            min(nKerRows, nKerRows+nImRows-r-padH), ...
                            max(1, 2-c+padW):...
                            min(nKerCols, nKerCols+nImCols-c-padW));
                        limitedKer = limitedKer.*sum(Ker(:))./ ...
                            sum(limitedKer(:));
                        ImOut(r, c, k) = sum(sum(limitedIm.*limitedKer));
                    end
                end
            end
        else    % method is 'none'
            ImOut(:, :, k) = Im(:, :, k);
            ImOut(padH+1:end-padH, padW+1:end-padW, k) = ...
                conv2(Im(:, :, k), Ker, 'valid');
        end
    end

    % Convert back to former image data type
    ImOut = cast(ImOut, classIm);
end
