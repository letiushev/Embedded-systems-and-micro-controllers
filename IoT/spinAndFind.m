%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                             %
%      Takeoff with the drone, rotate and take images         %
%                                                             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function spinAndFind()
    faceCount = 0;
    thePics={ones(1,1)};

    % How far do you want the drone to rotate while looking for people?
    viewAngle = pi/2;

    % Take this many pictures within the view angle defined above
    numberPics = 6;

    myDrone=ryze();
    myCam = camera(myDrone);
    droneFig = figure();
    ax = axes(droneFig);
    frame = snapshot(myCam);
    im = image(ax, zeros(size(frame), 'uint8'));
    droneFig = preview(myCam,im);
    movegui(droneFig,[800 200]);

    % Create the image processor.
    faceDetector = vision.CascadeObjectDetector;
    shapeInserter = vision.ShapeInserter('BorderColor','Custom','CustomBorderColor',[0 255 255],'LineWidth', 4);

    % Take off and move the drone into start position
    takeoff(myDrone);
    moveup(myDrone,'Distance',0.5);

    fig = figure('NumberTitle', 'off', 'MenuBar', 'none');
    movegui(fig,[400,-500]);

    for i = 1:numberPics
        myImage = snapshot(myCam);
        bbox = step(faceDetector, myImage);
        I_faces = step(shapeInserter, myImage, int32(bbox));
        faceCount = faceCount + size(bbox,1);
        turn(myDrone , viewAngle / numberPics );
        thePics{i}=I_faces;
        montage(thePics,'size',[numberPics 1],'thumbnailsize',[inf 3800]);   
    end

    flip(myDrone,'forward');
    land(myDrone);
    closePreview(myCam);
    faceNote = string(faceCount) + " faces detected";
    annotation('textbox', [.15, 0.00, 0.29, .25], 'string', faceNote)
    disp(faceCount);
end