% VERTDERIV  Vertical derivative of potential field data
%
% Usage: vd = vertderiv(im, order)
%
% Arguments:  im - Input potential field image.
%          order - Order of derivative 1st 2nd etc. Defaults to 1. 
%                  The order can be fractional if you wish, say, 1.5
%
% Returns:    vd - The vertical derivative.
%
% Vertical derivative filtering is done in the frequency domain whereby the
% Fourier transform of the filtered image F(VD) is obtained from the
% Fourier transform of the input image F(U) using
%      F(VD) =  F(U) * (sqrt(u^2 + v^2))^order
% where u and v are the spatial frequencies in x and y over the input grid.
%
% To minimise edge effect problems Moisan's Periodic FFT is used.  This avoids
% the need for data tapering.  
%
% References:  
% Richard Blakely, "Potential Theory in Gravity and Magnetic Applications"
% Cambridge University Press, 1996. pp 324-326.
%
% L. Moisan, "Periodic plus Smooth Image Decomposition", Journal of
% Mathematical Imaging and Vision, vol 39:2, pp. 161-179, 2011.
%
% See also: TILTDERIV, PERFFT2

% Copyright (c) Peter Kovesi
% Centre for Exploration Targeting
% The University of Western Australia
% peter.kovesi at uwa edu au
% 
% Permission is hereby granted, free of charge, to any person obtaining a copy
% of this software and associated documentation files (the "Software"), to deal
% in the Software without restriction, subject to the following conditions:
% 
% The above copyright notice and this permission notice shall be included in 
% all copies or substantial portions of the Software.
%
% The Software is provided "as is", without warranty of any kind.
%
% March 2015  

function  vd = vertderiv(im, order)

    if ~exist('order', 'var'), order = 1;  end
    
    [rows,cols,chan] = size(im);
    assert(chan == 1, 'Image must be single channel');
    assert(order >= 0, 'Derivative order must be >= 0');

    mask = ~isnan(im); 
    
    % Use Periodic FFT rather than data tapering to minimise edge effects.
    IM = perfft2(fillnan(im)); 
        
    % Generate horizontal and vertical frequency grids that vary from -0.5 to
    % 0.5.  This represents spatial frequency in grid units.
    [u1, u2] = meshgrid(([1:cols]-(fix(cols/2)+1))/(cols-mod(cols,2)), ...
			([1:rows]-(fix(rows/2)+1))/(rows-mod(rows,2)));

    % Quadrant shift to put 0 frequency at the corners. 
    u1 = ifftshift(u1);
    u2 = ifftshift(u2);

    % Form the filter by raising the frequency magnitude to the desired power,
    % then multiply by the Fourier transform of the image, invert the Fourier
    % transform, and finally mask out any NaN regions from the input image.
    vd = real(ifft2(IM .* (sqrt(u1.^2 + u2.^2)).^order)) .* double(mask);
    
