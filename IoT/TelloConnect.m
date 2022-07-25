%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                             %
%    This file manages the connection and control of a        %
%      DJI TELLO drone as the head of the IOT project.        %
%                                                             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% clearvars;
myDrone=ryze();
myCam = camera(myDrone);
droneFig = figure();
ax = axes(droneFig);
frame = snapshot(myCam);
im = image(ax, zeros(size(frame), 'uint8'));
droneFig = preview(myCam,im);
% takeoff(myDrone);
% turn(myDrone,deg2rad(45));
% land(myDrone);