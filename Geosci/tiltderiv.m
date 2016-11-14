% TILTDERIV  Tilt derivative of potential field data
%
% Usage: td = tiltderiv(im)
%
% Arguments:  im - Input potential field image.
%
% Returns:    td - The tilt derivative.
%
%
% Reference:  
% Hugh G. Miller and Vijay Singh. Potential field tilt - a new concept for
% location of potential field sources. Applied Geophysics (32) 1994. pp
% 213-217.
%
% See also: VERTDERIV

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

function  td = tiltderiv(im)
    
    [rows,cols,chan] = size(im);
    assert(chan == 1, 'Image must be single channel');

    % Use Farid and Simoncelli's 5-tap derivative filters to get the horizontal
    % gradient
    [gx, gy] = derivative5(im, 'x', 'y');
    gz = vertderiv(im, 1);
    
    td = atan(gz./sqrt(gx.^2 + gy.^2));