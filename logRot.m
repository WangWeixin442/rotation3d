function [ V, u, theta ] = logRot( R, format, checko )
% calculate the logarithm map from SO(3) to so(3)
% RM must be a 3-by-3-by-n matrix
% if strcmp(format,'ss') (default), V returns 3-by-3-by-n skew-symmetric
% matrices; if strcmp(format,'v'), V returns 3-by-n vectors.
% [u,theta] returns the axis-angle representation, u is 3-by-n, theta is
% 1-by-n.
% if checko==true (default), chech is the input matrices are orthogonal with
% determinant one.

if ~exist('checko','var') || isempty(checko)
    checko = true;
end
if ~exist('format','var') || isempty(format)
    format = 'ss';
end

% check size and orthogonality
if size(R,1)~=3 || size(R,2)~=3
    error('R must be of size 3-3-n');
end

orthogonalTolerance = 1e-10;
unitnessTolerance = 1e-10;
if checko
    if ~isempty(find(abs(sqrt(sum(R(:,1,:).^2))-1)>unitnessTolerance,1)) ||...
            ~isempty(find(abs(sqrt(sum(R(:,2,:).^2))-1)>unitnessTolerance,1)) ||...
            ~isempty(find(abs(sqrt(sum(R(:,3,:).^2))-1)>unitnessTolerance,1)) ||...
            ~isempty(find(abs(sum(R(:,1,:).*R(:,2,:)))>orthogonalTolerance,1)) ||...
            ~isempty(find(abs(sum(R(:,1,:).*R(:,3,:)))>orthogonalTolerance,1)) ||...
            ~isempty(find(abs(sum(R(:,2,:).*R(:,3,:)))>orthogonalTolerance,1)) ||...
            ~isempty(find(detM3(R)<0,1))
        error('R must be orthogonal matrices');
    end
end

% calculate log
u = reshape(cat(1,R(3,2,:)-R(2,3,:),R(1,3,:)-R(3,1,:),...
    R(2,1,:)-R(1,2,:)),3,[],1);
st = sqrt(sum(u.^2))/2;
ct = (traceM3(R)-1)/2;
u = u./sqrt(sum(u.^2));
theta = atan2(st,ct);

% special cases
ind0 = find(abs(st)<1e-10 & abs(ct-1)<1e-10);
if ~isempty(ind0)
    theta(ind0) = 0;
    u(:,ind0) = repmat([1;0;0],1,length(ind0));
end

indpi = find(abs(st)<1e-10 & abs(ct+1)<1e-10);
theta(indpi) = pi;

for i = 1:length(indpi)
    IR = eye(3)+R(:,:,indpi(i));
    u(:,indpi(i)) = IR(:,find(sum(IR.^2),1));
    u(:,indpi(i)) = u(:,indpi(i))/sqrt(sum(u(:,indpi(i)).^2));
end

% format result
if strcmp(format,'ss')
    V = zeros(3,3,size(R,3));
    V(1,2,:) = -reshape(u(3,:).*theta,1,1,[]);
    V(2,1,:) = reshape(u(3,:).*theta,1,1,[]);
    V(1,3,:) = reshape(u(2,:).*theta,1,1,[]);
    V(3,1,:) = -reshape(u(2,:).*theta,1,1,[]);
    V(2,3,:) = -reshape(u(1,:).*theta,1,1,[]);
    V(3,2,:) = reshape(u(1,:).*theta,1,1,[]);
elseif strcmp(format,'v')
    V = u.*theta;
else
    error('format must be ss or v');
end

end


function [ d ] = detM3( R )

d = R(1,1,:).*R(2,2,:).*R(3,3,:)+R(1,2,:).*R(2,3,:).*R(3,1,:)+...
    R(1,3,:).*R(2,1,:).*R(3,2,:)-R(1,3,:).*R(2,2,:).*R(3,1,:)-...
    R(1,2,:).*R(2,1,:).*R(3,3,:)-R(1,1,:).*R(2,3,:).*R(3,2,:);
d = reshape(d,1,[],1);

end


function [ tr ] = traceM3( R )

tr = R(1,1,:)+R(2,2,:)+R(3,3,:);
tr = reshape(tr,1,[],1);

end

