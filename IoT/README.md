![изображение](https://user-images.githubusercontent.com/91318186/180805243-ea5d82cf-bc86-4af7-9f48-73464116b603.png)

The head of this project is the MATLAB script on PC. This script controls the camera, making periodical screenshots and implement a face detection algorithm on it. 
If there was a face detected the control scripts connects to MQTT broker provider and sent the data to it which in our case is the message that there was a face detected. 
At the meantime control script fill the database with some logs about face detection event: time, IP, battery level. 
The database is provided by ThingSpeak software. 
On the other hand the Rasberry Pi, which is our another embedded layer, with the help of C program connects to MQTT broker provider and listens it, if there is a message that there were a face detected than we light the green LED on the RP with the help of low level C code.
