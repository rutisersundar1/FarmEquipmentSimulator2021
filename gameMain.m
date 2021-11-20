%FARM EQUIPMENT SIMULATOR 2021
%BUY NOW!

function gameMain
clear
clc

%%
%--------DEFINE CONSTANTS--------
%DEFINE IMAGE PATHS AND DISPLAY CONSTANTS
backgroundImg = 'Assets/background.png';
backgroundScale = 1.0;
rocketImg = 'Assets/Rocket.png';
rocketScale = 1.0;

windowSize = [1920 1080];
pixelsPerMeter = 100;

%ROCKET CONSTANTS

gravity = -9.806; %gravity, meters per second squared
dryMass = 100000; %dry mass, kilograms
fuelRate = 5000; %propellant burned per second at maximum throttle, kilograms per second
maxThrust = 5000000; %maximum thrust, newtons
frictionMultiplier = 0.98; %velocity is multiplied by this each frame to approximate friction
frameTime = 1 / 60;

%STARTING CONSTANTS
startingPropMass = 360000; %default prop mass, kilograms
startingPosition = windowSize/2; %default position, m
startingVelocity = [40,30]; %default velocity, m/s
startingAltitude = 0; %default altitude, meters
startingThrottle = 1; %default throttle, 0 to 1
acceleration = [0,0];

%COW CONSTANTS
cowPropMass = 1000; %mass of propellant given by cow, kilograms
cowAvgDist = 1000; %average distance between cows, meters
cowRandMax = 100; %maximum deviation from this average distance, meters

%CONTROL CONSTANTS
throttleInc = 1; %per second
rotationInc = 180; %degrees per second




%%
%--------INITIALIZE GAME WITH SPRITEKIT--------

%Initialize Game object
G = SpriteKit.Game.instance('Title', 'Farm Equipment Simulator 2021', 'Size', windowSize);
G.onKeyPress = @bufferKeys;

%Initialize Background object
bkg = SpriteKit.Background(backgroundImg);
bkg.Scale = backgroundScale;

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

%These need to be initialized to 0 (empty)
rocket.throttleBuffer = 0;
rocket.rotBuffer = 0;

%%
%Run game

G.play(@action); %Run game

%%
%To be run every frame
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
        propConsumed = 0;
        thrust_s = 0;
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
    end
    
    %Update the rocket's total mass.
    rocket.mass = rocket.propMass + rocket.dryMass; %kg
    
    %Calculate the forces acting on the rocket
    gravityForce = [0, rocket.mass * gravity]; %force of gravity, Newtons
    
    netForce = thrust_v + gravityForce; %net force, Newtons
    
    acceleration = netForce / rocket.mass; %acceleration, m/s^2
    
    rocket.velocity = rocket.velocity + acceleration * frameTime; %m/s
    
    %Rough approximation of friction
    rocket.velocity = rocket.velocity * frictionMultiplier; %m/s
    
    delta_pos = -1 * rocket.velocity * frameTime; %change in position this frame, meters
    
    rocket.altitude = rocket.altitude + delta_pos(2); %increment altitude
    
    %Scroll the background horizontally. It requires a positive value, so we do this.
    if delta_pos(1) < 0
        bkg.scroll('right', abs(delta_pos(1) * pixelsPerMeter));
    elseif delta_pos(1) > 0
        bkg.scroll('left', abs(delta_pos(1) * pixelsPerMeter));
    end
    
    %Scroll the background vertically. It requires a positive value, so we do this.
    if delta_pos(2) < 0
        bkg.scroll('down', abs(delta_pos(2) * pixelsPerMeter));
    elseif delta_pos(2) > 0
        bkg.scroll('up', abs(delta_pos(2) * pixelsPerMeter));
    end
            
end

end
