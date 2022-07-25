%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                             %
%    This file manages the connection and control of a        %
%      face detection IOT application using MQTT              %
%                                                             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Create Drone connection
system('netsh wlan connect name="TELLO-5A8015" interface="WiFi"');
pause(3);
myDrone=ryze();
myCam = camera(myDrone);
disp('Drone connection and camera estabilished.')

batterypercent = -1;
ipaddress = '';
flag = 1; % Boolean flag
while(flag)
    % Take a picture
    droneFig = figure();
    ax = axes(droneFig);
    videoFrame = snapshot(myCam);
    
    % Turn on drone live feed
    im = image(ax, zeros(size(videoFrame), 'uint8'));
    droneFig = preview(myCam,im);

    % Run a face detection algorithm 
    faceDetector = vision.CascadeObjectDetector();
    bbox = step(faceDetector, videoFrame);

    % Draw the returned bounding box around the detected face.
    videoOut = insertObjectAnnotation(videoFrame,'rectangle',bbox,'Face');
    figure, imshow(videoOut), title('Detected face');
    disp('Picture taken');
    pause(3); % Take a picture every 3 seconds
    
    if(size(bbox, 1))
       saveas(gcf,'DetectedFace.png'); % Save the face as a file
       flag = 0;
       batterypercent = myDrone.BatteryLevel;
       ipaddress = myDrone.IPAddress;
       disp('Face detected on drone image.');
    end
end

clear('myCam');
clear('myDrone');
disp('There is a face found');

% Switch to wifi that the pi is connected to
% system('netsh wlan connect name="Kknet" interface="WiFi"'); % Change to network
system('netsh wlan connect name="Kk-WiFi" interface="WiFi"'); % Change to network
pause(3);

% % Uncomment this block to place the image file onto the raspberry pi [if on the same network - ip address has to be input]
% mypi = raspi('192.168.0.17', 'pi', 'raspberry'); % Input pi IP address here
% putFile(mypi,'DetectedFace.png','/home/pi/desktop'); % Copy image to rpi
% disp('Connected to Raspberry pi');

% Publish message on MQTT
myMQTT = mqttclient('tcp://broker.hivemq.com'); % Create topic on hivemq
write(myMQTT, 'ERTOS_GDN', 'There was a face detected!'); % Publish a message on the topic
disp('MQTT message published');

response = thingSpeakWrite(1721770,... % Which variables to write into
    ['There was a face detected!', batterypercent, ipaddress], ... % Which variables to send
    'WriteKey','YZ22ZCJH2CIVXO4I') % API key

