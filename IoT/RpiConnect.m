%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                             %
%    This file manages the connection and control of a        %
%      Raspberry pi as a client for our IOT Project           %
%                                                             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

mypi = raspi('192.168.0.17', 'pi', 'raspberry'); % Connect to raspberry
system(mypi, 'mosquitto_sub -h broker.hivemq.com -t ERTOS_GDN -v'); % Subscribe to topic
myMQTT = mqtt('tcp://broker.hivemq.com'); % Create topic on hivemq
publish(myMQTT, 'ERTOS_GDN', 'There was a face detected!'); % Publish a message on the topic
