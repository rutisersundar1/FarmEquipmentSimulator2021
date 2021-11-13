%FARM EQUIPMENT SIMULATOR 2021
%BUY NOW!

clear
clc

%%
%--------VALUES--------
%Changing rocket physics values
acceleration = [0,0]; %xy acceleration, meters per second squared.
velocity = [0,0]; %xy velocity, meters per second
position = [0,0]; %should not change since the rocket will be centered
rotation = 0; %degrees, positive is clockwise
throttle = 0; %0 to 1
mass = 0; %mass, kilograms
altitude = 0; %meters above sea level
propMass = 0; %mass of propellant in kilograms
propConsumed = 0; %propellant consumed each frame, kilograms
thrust_s = 0; %scalar thrust, newtons
thrust_v = [0,0]; %vector thrust, newtons
gravityForce = [0,0]; %force of gravity, newtons
delta_x = [0,0]; %change in position each frame, meters

%--------CONSTANTS--------
throttleInc = 0.1; %per frame
rotationInc = 5; %degrees per frame

%ROCKET CONSTANTS
gravity = -9.806; %gravity, meters per second squared
dryMass = 100000; %dry mass, kilograms
startingPropMass = 300000; %default prop mass, kilograms
fuelRate = 100; %propellant burned per second at maximum throttle, kilograms per second

%COW CONSTANTS
cowPropMass = 1000; %mass of propellant given by cow, kilograms
cowAvgDist = 1000; %average distance between cows, meters
cowRandMax = 100; %maximum deviation from this average distance, meters

%%
%INITIALIZE GAME

keybuffer = keyBuffer(); %Buffer buffered keys with a key buffer.

gameFigure = figure('Color', 'blue'); %Initialize the game figure.
set(gameFigure, 'KeyPressFcn', @bufferKeys); %Assign the key buffer to handle key presses.

gameState = "paused"; %game state
propMass = startingPropMass;
mass = propMass + dryMass;
altitude = 0;
rotation = 270;

%% 
%RUN GAME

while gameState ~= "crashed"
    frameStart = tic(); %start frame timer
    throttleinputs = getThrottleInput(keybuffer);
    rotInput = getRotInput(keybuffer);
    
    %Handle throttle inputs. z is max. x is cut.
    %w is increase, s is decrease
    switch(throttleinputs)
        case "z"
            throttle = 1;
        case "x" 
            throttle = 0;
        case "w" 
            throttle = throttle + throttleInc * toc(frameStart);
        case "s"
            throttle = throttle - throttleInc * toc(frameStart);
    end
    
    %Constrain throttle between 0 and 1.
    if throttle > 1
        throttle = 1;
    end
    
    if throttle < 0
        throttle = 0;
    end
    
    %Handle rotation inputs. Right is d and left is a.
    switch(rotInput)
        case "d"
            rotation = rotation + rotationInc * toc(frameStart);
        case "a"
            rotation = rotation - rotationInc * toc(frameStart);
    end
   
    %Constrain rotation between 0 and 360 by adding or subtracting 360.
    while rotation > 360
        rotation = rotation - 360;
    end
    
    while rotation < 0
        rotation = rotation + 360;
    end
    
    thrust_s = maxThrust * throttle; %scalar thrust value, Newtons
    thrust_v = [thrust_s * cosd(rotation), thrust_s * sind(rotation)]; %vector thrust force, Newtons

    physicsFrameTime = toc(frameStart); %seconds
    
    %amount of propellant consumed this frame
    propConsumed = fuelRate * throttle * physicsFrameTime;

    %subtract consumed propellant and set mass
    propMass = propMass - propConsumed; %kg
    mass = propMass + dryMass; %kg
    
    %Calculate forces
    gravityForce = [0, mass * gravity]; %force of gravity, Newtons
    
    netForce = thrust_v + gravityForce; %net force, Newtons
    
    %Apply acceleration
    acceleration = netForce / mass; %acceleration, meters per second squared
    
    velocity = velocity + acceleration * physicsFrameTime; %meters per second
    
    delta_x = velocity * physicsFrameTime; %movement this frame, meters
    altitude = altitude + delta_x(2); %increment altitude as necessary
    
    %Move background and update scoring
    %translateBg(Background, -1 * delta_x);
    %scoreCounter(ScoreCounter, altitude, rotation, physicsFrameTime);
    %score = getScore(ScoreCounter);
end

%Just because I can't pass arguments in through a callback. Sigh.
function bufferKeys(~, event)
    bufferKeyInputs(keyBuffer, event);
end





