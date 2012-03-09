function b = isintersect(P1, P2)
% function b = isintersect(P1, P2)
% Check if two polygons intersect
% INPUTS:
% P1 and P2 are two-row arrays, each column is a vertice, assuming
% ordered along the boundary
% OUTPUT:
% b is true if two polygons intersect 

c = poly2poly(P1, P2);
if isempty(c)
    b = inpolygon(P2(1,1),P2(2,1),P1(1,:),P1(2,:)) || ...
        inpolygon(P1(1,1),P1(2,1),P2(1,:),P2(2,:));
else
    b = true;
end

end % isintersect

function c = poly2poly(P1, P2)
% function c = poly2poly(P1, P2)
% Intersection of two polygons P1 and P2.
% INPUTS:
% P1 and P2 are two-row arrays, each column is a vertice
% OUTPUT:
% c is also two-row arrays, each column is an intersecting point

% Pad the first point to the end if necessary
if ~isequal(P1(:,1),P1(:,end))
    P1 = [P1 P1(:,1)];
end
if ~isequal(P2(:,1),P2(:,end))
    P2 = [P2 P2(:,1)];
end

% swap P1 P2 so that we loop on a smaller one
if size(P1,2) > size(P2,2)
    [P1 P2] = deal(P2, P1);
end

c = zeros(2,0);
% Loop over segments of P1
for n=2:size(P1,2)
    c = [c seg2poly(P1(:,n-1:n), P2)]; %#ok
end

end % poly2poly

function c = seg2poly(s1, P)
% function c = seg2poly(s1, P)
% Check if a segment (2 x 2) segment s1 intersects with a polygon P.
% s(:,1) is the first point s(:,2) is the the second point of the segment.
% P is (2 x n) arrays, each column is a vertices

% Translate and rotation so that first point is origin
% the second point is on y-axis
a = s1(:,1);
M = bsxfun(@minus, P, a);
b = s1(:,2)-a;
x = [b(2) -b(1)]*M;
sx = sign(x);
% x -coordinates has opposite signs
ind = sx(1:end-1).*sx(2:end) <= 0;
if any(ind)
    ind = find(ind);
    % cross point to y-axis
    x1 = x(ind);
    x2 = x(ind+1);
    d = b.'/(b(1)^2+b(2)^2);
    y1 = d*M(:,ind);
    y2 = d*M(:,ind+1);
    dx = x2-x1;
    % We won't bother with the degenerate case of dx=0 and x1=0
    y = (y1.*x2-y2.*x1)./dx;
    % Check if the cross point is inside the segment
    ind = y>=0 & y<1;
    if any(ind)
        c = bsxfun(@plus, b*y(ind), a);
    else
        c = zeros(2,0);
    end
else
    c = zeros(2,0);
end

end % seg2poly

% Bruno