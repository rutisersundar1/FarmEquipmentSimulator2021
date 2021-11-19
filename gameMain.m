%FARM EQUIPMENT SIMULATOR 2021
%BUY NOW!

clear
clc

%%
%--------VALUES--------
%Changing rocket physics values
acceleration = [0,0]; %xy acceleration, meters per second squared.
velocity = [0,0]; %xy velocity, meters per second
position = [0,0.5]; %should not change since the rocket will be centered
rotation = 0; %degrees, positive is clockwise
throttle = 0; %0 to 1
mass = 0; %mass, kilograms
altitude = 0; %meters above sea level
propMass = 0; %mass of propellant in kilograms
propConsumed = 0; %propellant consumed each frame, kilograms
thrust_s = 0; %scalar thrust, newtons
thrust_v = [0,0]; %vector thrust, newtons
gravityForce = [0,0]; %force of gravity, newtons
delta_pos = [0,0]; %change in position each frame, meters
frictionMultiplier = 0.98; %velocity is multiplied by this each frame to approximate friction
frameRate = 60; %frames per second
frameTime = 1/frameRate; %seconds
metersToPixels = 2; %meters per pixel

%--------CONSTANTS--------
throttleInc = 1; %per second
rotationInc = 180; %degrees per second

%ROCKET CONSTANTS
gravity = -9.806; %gravity, meters per second squared
dryMass = 100000; %dry mass, kilograms
startingPropMass = 360000; %default prop mass, kilograms
fuelRate = 5000; %propellant burned per second at maximum throttle, kilograms per second
maxThrust = 5000000; %maximum thrust, newtons

%COW CONSTANTS
cowPropMass = 1000; %mass of propellant given by cow, kilograms
cowAvgDist = 1000; %average distance between cows, meters
cowRandMax = 100; %maximum deviation from this average distance, meters

%%
%INITIALIZE GAME

%Game States
%1 = running
%0 = paused
%-1 = close (by x button)
game = SpriteKit.Game.instance('Title', 'Farming Simulator 2021', 'Size', [600, 600]);
bkg = SpriteKit.Background('Assets/background.png');

gameFigure = figure('Color', 'blue'); %Initialize the game figure.
gameFigure.UserData = struct('bufferedRot', 0, 'bufferedThrottle', 0,...
    'score', 0, 'gameState', 1);

%Key buffering function to handle key presses
set(gameFigure, 'KeyPressFcn', @bufferKeys);

pause(0.00001);
%This function runs when the user closes the window through the X button.
%It will print the user's score, close the window, and stop the game.
%set(gameFigure, 'CloseRequestFcn', @closeRequestMgr); 
pause(0.01);

%Set the figure's name
set(gameFigure, 'Name', 'Farm Equipment Simulator 2021');
%Go fullscreen
set(gameFigure, 'WindowState', 'maximized');
pause(0.01);

propMass = startingPropMass;
mass = propMass + dryMass;
altitude = 0;
rotation = 0;

h = axes('position', [position(1), position(2), 0.4, 0.4]);
set(h, 'Color', 'none');

%%
%LOAD ASSETS

rocket = SpriteKit.Sprite('State');
rocket.initState('Standard', 'Assets/Rocket.png', true);
rocket.Scale = 2;
rocket.State = 'Standard';

%rocketAlpha = imread('assets/RocketAlpha.png'); %rocket alpha because MatLab transparency is horrible.
%rocketAlpha = rocketAlpha(:,:,1);

%% 
%RUN GAME

while true
    elapsedTime = tic();
    
    %If the user has paused
    if gameFigure.UserData.gameState == 0
        
    else if gameFigure.UserData.gameState == 1
            %Take inputs from buffer
            throttleInput = gameFigure.UserData.bufferedThrottle;
            rotInput = gameFigure.UserData.bufferedRot;
            
            %fprintf("throttleInput: %i, rotInput, %i\n", throttleInput, rotInput);
            
            %Update throttle and rotation
            throttle = calcThrottle(throttleInput, throttle, throttleInc, frameTime);
            rotation = calcRotation(rotInput, rotation, rotationInc, frameTime);
            
            %Clear inputs so they aren't used again next frame
            gameFigure.UserData.bufferedThrottle = 0;
            gameFigure.UserData.bufferedRot = 0;
            
            if propMass <= 0
                propmass = 0;
                propConsumed = 0;
                thrust_s = 0;
                thrust_v = [0,0];
            else
                %Calculate thrust
                thrust_s = maxThrust * throttle; %scalar thrust value, Newtons
                thrust_v = [thrust_s * sind(rotation), thrust_s * cosd(rotation)]; %vector thrust force, Newtons
                
                %amount of propellant consumed this frame
                propConsumed = fuelRate * throttle * frameTime;

                %subtract consumed propellant and set mass
                propMass = propMass - propConsumed; %kg

                if propMass < 0
                    propMass = 0;
                end
            end
            mass = propMass + dryMass; %kg
            
            %Calculate forces
            gravityForce = [0, mass * gravity]; %force of gravity, Newtons
            
            netForce = thrust_v + gravityForce; %net force, Newtons
            
            %Apply acceleration
            acceleration = netForce / mass; %acceleration, meters per second squared
            
            velocity = velocity + acceleration * frameTime; %meters per second
            velocity = velocity * frictionMultiplier; %rough approximation of air drag
            
            delta_pos = velocity * frameTime; %movement this frame, meters
            altitude = altitude + delta_pos(2); %increment altitude as necessary
                        
            position = position + delta_pos;
            
            if position(2) < 0
                position(2) = 0;
                if velocity(2) < 0
                    velocity(2) = 0;
                end
            end
            
            if position(1) < 0
                position(1) = 0;
                if velocity(1) < 0
                    velocity(1) = 0;
                end
            end
            
            if position(1) > 1
                position(1) = 1;
                if velocity(1) > 0
                    velocity(1) = 0;
                end
            end
            
            %Move background and update scoring
            
            if delta_pos(1) <= 0
                bkg.scroll('right', -delta_pos(1) * metersToPixels);
            else
                bkg.scroll('left', delta_pos(1) * metersToPixels);
            end
            
            rocket.Location = position;

%             set(h, 'position', [position(1), position(2), 0.4, 0.4]);
%             rotatedRocketImg = imrotate(rocketImg, -rotation, 'nearest', 'loose');
%             rotatedRocketAlpha = imrotate(rocketAlpha, -rotation, 'nearest', 'loose');
%             %rotatedRocketImg(rotatedRocketImg == 0) = 255;
%             image(rotatedRocketImg, 'AlphaData', rotatedRocketAlpha);
       
%            axis off
            
%            text(0, -20, string(propMass));
        else %Something went wrong otherwise.
            delete(gameFigure);
            return
        end
    end
    
    drawnow
    
    %Wait so that it continues at the correct framerate
    if elapsedTime < frameTime
        pause(frameTime - toc(elapsedTime));
    end
end
