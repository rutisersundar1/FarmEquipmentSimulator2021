%FARM EQUIPMENT SIMULATOR 2021
%BUY NOW!

function gameMain
clear
clc

%% Define Constants
%DEFINE IMAGE PATHS AND DISPLAY CONSTANTS
%pro tip: don't change these scale values! It causes the game to run at
%around 10 fps. Just scale the image. It's terrible.
backgroundImg = 'Assets/background.png';
backgroundScale = 1;
rocketImg = 'Assets/Rocket.png';
rocketScale = 1;

%{
exhaustParticleLightImg = 'Assets/ExhaustParticle.png';
exhaustParticleDarkImg = 'Assets/ExhaustParticle2.png';
%}

cowImg = 'Assets/cow.png'; %Cow png
cowScale = 1.0;
noneImg = 'Assets/noneImg.png'; %1x1 transparent png

windowSize = [1280 720];
pixelsPerMeter = 100/1920 * windowSize(1);

%This is my fix for the memory leak. The user is wrong.
if windowSize(1) > 1280 || windowSize(2) > 720
    disp("Higher resolutions than 1280x720 are not recommended as they cause a memory leak. I have no clue why and I am not going to try and fix this because I don't have time.");
end

%FUEL GAUGE CONSTANTS

%width of fuel gauge in px
fuelGaugeWidth = (100 / 1920 * windowSize(1));
%Fuel gauge height when full
fuelGaugeMaxHeight = windowSize(2) / 2;
%Fuel gauge offset from bottom-left corner of screen
fuelGaugeOffset = [(50/1080 * windowSize(2)) , windowSize(2) / 5];

%The x coordinate of the label for the fuel gauge
fuelTextX = fuelGaugeOffset(1) + fuelGaugeWidth/5;
%The y coordinate of the label for the fuel gauge
fuelTextY = fuelGaugeMaxHeight + fuelGaugeOffset(2) + windowSize(2) / 40;

fuelGaugeFillColor = [1, .5, 0];
fuelGaugeEdgeColor = [0, 0, 0];
fuelGaugeLineWidth = 3;

%ROCKET CONSTANTS

gravity = -9.806; %gravity, meters per second squared
dryMass = 100000; %dry mass, kilograms
fuelRate = 5000; %propellant burned per second at maximum throttle, kilograms per second
maxThrust = 5000000; %maximum thrust, newtons
maxPropMass = 360000; %maximum propellant mass, kilograms
frictionMultiplier = 0.98; %velocity is multiplied by this each frame to approximate friction
frameTime = 1 / 60; 

%PARTICLE CONSTANTS
%{
maxParticleCount = 100; %maximum number of particles
particleLifeSpan = [60,120]; %particle life span min/max in frames
%}

%STARTING CONSTANTS
startingPropMass = 360000; %default prop mass, kilograms
%startingPropMass = 10000; %testing low fuel behavior
startingPosition = windowSize/2; %default position, m
startingVelocity = [0,0]; %default velocity, m/s
startingAltitude = 0; %default altitude, meters
startingThrottle = 1; %default throttle, 0 to 1
acceleration = [0,0];

%COW CONSTANTS
cowPropMass = 1000; %mass of propellant given by cow, kilograms

cowRandVals = [10, 30]; %minimum and maximum distance to next cow, meters

propCowPity = 0.1; %value of the maximum fuel at which cow is force spawned

cowSpawnMargin = 100; %distance from edge the cow should spawn, pixels
cowSpawnY = 400; %distance from bottom of the screen the cow should spawn, pixels
cowKillMargin = 400; %distance outside of the screen at which the cow should stop existing

%CONTROL CONSTANTS
throttleInc = 1; %per second
rotationInc = 180; %degrees per second

%THINGS TO INITIALIZE IN THE HOPES THAT IT FIXES THE MEMORY LEAK
thrust_s = 0;
thrust_v = [0,0];
acceleration = [0,0];
gravityForce = [0,0];
netForce = [0,0];
propConsumed = 0;
delta_pos = 0;
collide = false;
target = 'rocket';

%% Initialize Game with SpriteKit
%Initialize Game object
G = SpriteKit.Game.instance('Title', 'Farm Equipment Simulator 2021', 'Size', windowSize);


%Initialize Background object
bkg = SpriteKit.Background(backgroundImg);
bkg.Scale = backgroundScale;

%% Rocket Sprite

%Create rocket Sprite object
rocket = SpriteKit.Sprite('rocket');

%Set up the default state for the rocket and give it its image
rocket.initState('rocket1', rocketImg, true);

%Give the rocket its necessary properties. These are per rocket in case
%multiplayer is wanted in the future or in case multiple rocket models
%would be wanted.
addprop(rocket, 'velocity'); %1x2 velocity meters per second
addprop(rocket, 'propMass'); %propellant mass kg
addprop(rocket, 'dryMass'); %dry mass kg
addprop(rocket, 'mass'); %total mass, kilograms
addprop(rocket, 'fuelRate'); %fuel rate at max throttle kg/s
addprop(rocket, 'maxThrust'); %maximum thrust, N
addprop(rocket, 'throttle'); %throttle, 0 to 1
addprop(rocket, 'throttleBuffer'); %key buffer for throttle keys
addprop(rocket, 'rotBuffer'); %key buffer for rotation keys
addprop(rocket, 'altitude'); %altitude, meters
addprop(rocket, 'maxPropMass'); %maximum prop mass, kg

%Initialize rocket physics and give it its values
rocket.Location = startingPosition;
rocket.velocity = startingVelocity;
rocket.State = 'rocket1';
rocket.Scale = rocketScale;
rocket.altitude = startingAltitude;
rocket.propMass = startingPropMass;
rocket.dryMass = dryMass;
rocket.mass = startingPropMass + dryMass;
rocket.fuelRate = fuelRate;
rocket.maxThrust = maxThrust; 
rocket.throttle = startingThrottle;
rocket.maxPropMass = maxPropMass;

%These need to be initialized to 0 (empty)
rocket.throttleBuffer = 0;
rocket.rotBuffer = 0;

%% Exhaust particle sprite
%haha with these memory issues? nah
%{
%Create particle Sprite object
particle = SpriteKit.Sprite('particle');

%Set up the states for the particle
particle.initState('exhaustLight', exhaustParticleLightImg, true);
particle.initState('exhaustDark', exhaustParticleDarkImg, true);

addprop(particle, 'lifetime'); %particle lifetime in seconds
addprop(particle, 'velocity'); %particle velocity in meters per second
%}
%% Cow Sprite
cow = SpriteKit.Sprite('cow');

%Set up state
cow.initState('on', cowImg, true);
cow.initState('off', noneImg, true); %when the cow has been collected, this allows it to disappear

%Give it its properties
addprop(cow, 'propAmt'); %amount of propellant in the cow, kg
addprop(cow, 'xToNextCow'); %distance until next cow, meters
cow.State = 'off';
cow.Scale = cowScale;

cow.propAmt = cowPropMass; %Amount of propellant in the cow
cow.xToNextCow = randi(cowRandVals); %meters since last cow collected

%% Run Game

%Set up the key buffering system
G.onKeyPress = {@bufferKeys, rocket};

%Draw fuel gauge rectangles
%Outline rectangle that shows the maximum size
fuelGaugeRect = rectangle('Position', [fuelGaugeOffset, fuelGaugeWidth, fuelGaugeMaxHeight]);

fuelGaugeHeight = fuelGaugeMaxHeight * rocket.propMass / rocket.maxPropMass;

%Fill rectangle that shows how much propellant you have
fuelFillRect = rectangle('Position', [fuelGaugeOffset, fuelGaugeWidth, fuelGaugeHeight]);

%Set colors
fuelFillRect.FaceColor = fuelGaugeFillColor;
fuelFillRect.EdgeColor = fuelGaugeEdgeColor;
fuelFillRect.LineWidth = fuelGaugeLineWidth;

fuelGaugeRect.EdgeColor = fuelGaugeEdgeColor;
fuelGaugeRect.LineWidth = fuelGaugeLineWidth;

%Draw the label for the fuel gauge
fuelText = text(fuelTextX, fuelTextY, "Fuel");
fuelText.FontSize = 14;

G.play(@action); %Run game

%% action to be run every frame
function action 
    %Read key inputs from the buffer and update throttle and rotation.
    %calcThrottle and calcRotation handle constraining the throttle and
    %rotation between their needed values.
    rocket.throttle = calcThrottle(rocket.throttleBuffer,...
        rocket.throttle, throttleInc, frameTime);
    rocket.Angle = calcRotation(rocket.rotBuffer, rocket.Angle,...
        rotationInc, frameTime);
    
    %Clear inputs so they aren't used again next frame
    rocket.throttleBuffer = 0;
    rocket.rotBuffer = 0;
    
    %Handle throttle: check for propellant out, calculate thrust vector,
    %and subtract propellant.
    if rocket.propMass <= 0
        rocket.propMass = 0;
        
        %propConsumed = 0; %not necessary
        %thrust_s = 0; %not necessary
        
        thrust_v = [0,0];   
    else
        %Calculate thrust
        thrust_s = rocket.maxThrust * rocket.throttle; %scalar thrust value, Newtons
        thrust_v = [thrust_s * sind(rocket.Angle),...
            thrust_s * cosd(rocket.Angle)]; %vector thrust force, Newtons
        
        %amount of propellant consumed this frame
        propConsumed = rocket.fuelRate * rocket.throttle * frameTime;
        
        %subtract consumed propellant and set mass
        rocket.propMass = rocket.propMass - propConsumed; %kg
        
        if rocket.propMass < 0
            rocket.propMass = 0;
        end
        
        %This was originally in a separate if statement, but for some
        %reason that completely destroyed performance at low fuel levels. I
        %have no clue why. FPS dropped to 8 to 20 from 30, but putting it
        %here fixes that. 
        
        %draw fuel gauge
        fuelGaugeHeight = fuelGaugeMaxHeight * rocket.propMass / rocket.maxPropMass;
        fuelFillRect.Position(4) = fuelGaugeHeight;
    end
    
    %Update the rocket's total mass.
    rocket.mass = rocket.propMass + rocket.dryMass; %kg
    %disp(rocket.mass);
    %Calculate the forces acting on the rocket
    gravityForce = [0, rocket.mass * gravity]; %force of gravity, Newtons
    
    netForce = thrust_v + gravityForce; %net force, Newtons
    
    acceleration = netForce / rocket.mass; %acceleration, m/s^2
    
    rocket.velocity = rocket.velocity + acceleration * frameTime; %m/s
    
    %Rough approximation of friction
    rocket.velocity = rocket.velocity * frictionMultiplier; %m/s
    
    delta_pos = rocket.velocity * frameTime; %change in position this frame, meters
    
    rocket.altitude = rocket.altitude + delta_pos(2); %increment altitude
    
    %Test to see if drawing a rectangle over a game works
    %rectangle('Position', [10 20 30 40]);
    
    %Scroll the background horizontally. It requires a positive value, so we do this.
    if delta_pos(1) < 0
        bkg.scroll('right', abs(delta_pos(1) * pixelsPerMeter));
    elseif delta_pos(1) > 0
        bkg.scroll('left', abs(delta_pos(1) * pixelsPerMeter));
    end
    
    %Scroll the background vertically. It requires a positive value, so we do this.
    if delta_pos(2) < 0
        bkg.scroll('up', abs(delta_pos(2) * pixelsPerMeter));
    elseif delta_pos(2) > 0
        bkg.scroll('down', abs(delta_pos(2) * pixelsPerMeter));
    end
    
    %fprintf("delta_pos %i, %i\n", delta_pos(1), delta_pos(2));
            
    %COW HANDLING
    
    %Scroll the cow
    cow.Location = cow.Location + [1, -1] .* delta_pos * pixelsPerMeter;
    %fprintf("cow location %i, %i", cow.Location(1), cow.Location(2));
    
    %Add the x-movement to the cow's counter
    cow.xToNextCow = cow.xToNextCow - abs(delta_pos(1));
    
    %If the rocket has travelled far enough since the last cow, spawn a new
    %one
    %Not the memory leak culprit

    if (cow.xToNextCow <= 0) && (cow.State == "off")
        cow.State = 'on';
        
        %If the rocket is moving to the right, spawn on the right side
        if rocket.velocity <= 0
            %Spawn on the right side of the screen
            cow.Location = [windowSize(1) - cowSpawnMargin, cowSpawnY];
        else %If it's moving to the left, spawn on the left side
            %Spawn on the left side of the screen
            cow.Location = [cowSpawnMargin, cowSpawnY];
        end
        
        cow.xToNextCow = randi(cowRandVals); %reset cow-nter
    end
    
    %This kills performance for some reason, so we're ditching that
    %Secret mechanic, don't tell anyone! If the rocket's propellant gets
    %quite low, spawn a new cow regardless of cow timer :)
    if rocket.propMass <= propCowPity * rocket.maxPropMass 
        if cow.State == "off"
            cow.State = 'on';

            %If the rocket is moving to the right, spawn on the right side
            if rocket.velocity >= 0
                %Spawn on the right side of the screen
                cow.Location = [windowSize(1) - cowSpawnMargin, cowSpawnY];
            else %If it's moving to the left, spawn on the left side
                %Spawn on the left side of the screen
                cow.Location = [cowSpawnMargin, cowSpawnY];
            end

            cow.xToNextCow = randi(cowRandVals); %reset cow-nter
        end
    end

    %Check that the cow is not way off screen
    %It's possible that the cow goes through the collision sprites around
    %the screen otherwise. Maybe.
    if cow.Location(1) < -cowKillMargin
        cow.State = 'off';
    elseif cow.Location(1) > windowSize(1) + cowKillMargin
        cow.State = 'off';
    elseif cow.Location(2) > windowSize(2) + cowKillMargin
        cow.State = 'off';
    elseif cow.Location(2) < -cowKillMargin
        cow.State = 'off';
    end
    
    
    %Check the cow's collisions
    %Not the memory leak culprit...
    [collide, target] = SpriteKit.Physics.hasCollision(cow);
    if collide
        switch target.ID
            %Disable the cow if it leaves the screen
            case 'topborder'
                cow.State = 'off';
            case 'bottomborder'
                cow.State = 'off';
            case 'leftborder'
                cow.State = 'off';
            case 'rightborder'
                cow.State = 'off';
                
            %Give the rocket propellant if it hits the cow
            case 'rocket'
                %Only give propellant if the cow is enabled (otherwise,
                %it's a 1x1 transparent png and its position is irrelevant
                if cow.State == "on"
                    %Give the rocket more propellant
                    rocket.propMass = rocket.propMass + cow.propAmt;
                    
                    %Make sure the rocket doesn't exceed its maximum
                    %propellant mass
                    if rocket.propMass > rocket.maxPropMass
                        rocket.propMass = rocket.maxPropMass;    
                    end
                    
                    cow.xToNextCow = randi(cowRandVals); %Reset the counter for next cow spawn
                    cow.State = 'off';
                end
        end
    end
    
    
end
end
