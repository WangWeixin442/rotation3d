function [ R ] = eul2rot( e, seq )
% euler angle is represneted as 3-2-1 body sequence (roll, pitch yaw)
% e is a 3-by-n or n-by-3 matrix
% R returns a 3-by-3-by-n matrix
% seq is the sequence of Euler angles: 'zyx' (default) or 'zyz'

if ~exist('seq','var') || isempty(seq)
    seq = 'zyx';
end

% check size
if size(e,2) == 3
    e = e';
elseif size(e,1) ~= 3
    error('e must be of size 3-n or n-3');
end

% calculate
if strcmpi(seq,'zyx')
    R(1,1,:) = cos(e(2,:)).*cos(e(3,:));
    R(1,2,:) = -cos(e(1,:)).*sin(e(3,:))+sin(e(1,:)).*sin(e(2,:)).*cos(e(3,:));
    R(1,3,:) = sin(e(1,:)).*sin(e(3,:))+cos(e(1,:)).*sin(e(2,:)).*cos(e(3,:));
    R(2,1,:) = cos(e(2,:)).*sin(e(3,:));
    R(2,2,:) = cos(e(1,:)).*cos(e(3,:))+sin(e(1,:)).*sin(e(2,:)).*sin(e(3,:));
    R(2,3,:) = -sin(e(1,:)).*cos(e(3,:))+cos(e(1,:)).*sin(e(2,:)).*sin(e(3,:));
    R(3,1,:) = -sin(e(2,:));
    R(3,2,:) = sin(e(1,:)).*cos(e(2,:));
    R(3,3,:) = cos(e(1,:)).*cos(e(2,:));
elseif strcmpi(seq,'zyz')
    se = sin(e);
    ce = cos(e);
    
    R(1,1,:) = ce(1,:).*ce(2,:).*ce(3,:)-se(1,:).*se(3,:);
    R(1,2,:) = -ce(1,:).*ce(2,:).*se(3,:)-se(1,:).*ce(3,:);
    R(1,3,:) = ce(1,:).*se(2,:);
    R(2,1,:) = se(1,:).*ce(2,:).*ce(3,:)+ce(1,:).*se(3,:);
    R(2,2,:) = -se(1,:).*ce(2,:).*se(3,:)+ce(1,:).*ce(3,:);
    R(2,3,:) = se(1,:).*se(2,:);
    R(3,1,:) = -se(2,:).*ce(3,:);
    R(3,2,:) = se(2,:).*se(3,:);
    R(3,3,:) = ce(2,:);
end

end

