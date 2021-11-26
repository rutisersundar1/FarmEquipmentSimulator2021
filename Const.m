%Stores constant values that need to be accessed from many locations.
classdef Const
    properties (Constant)
        %% DISPLAY CONSTANTS
        %Scale values should not be changed from 1, as it has a significant
        %performance impact.
        backgroundImg = 'Assets/background.png'; %Path to the background image
        backgroundScale = 1; %Do not change scale values.
        rocketImg = 'Assets/Rocket.png'; %Path to the rocket image
        rocketScale = 1; %Do not change scale values.
        
        cowImg = 'Assets/cow.png'; %Path to the cow image
        cowScale = 1; %Do not change scale values.
        noneImg = 'Assets/noneImg.png'; %1x1 transparent png.
        
        windowSize = [1280 720]; %Window size, pixels.
        
        pixelsPerMeter = Const.windowSize(1) * 100/1920;
        
        %% FUEL GAUGE CONSTANTS
        
        fuelGaugeWidth = Const.windowSize(1) * 100/1920
        fuelGaugeMaxHeight = Const.windowSize(2) / 2;
        fuelGaugeOffset = [ 50/1808 * Const.windowSize(2), Const.windowSize(2) / 5];
        
        %X and Y coordinates of the fuel gauge's text label
        fuelTextX = Const.fuelGaugeOffset(1) + Const.fuelGaugeWidth/5;
        fuelTextY = Const.fuelGaugeOffset(2) + Const.fuelGaugeMaxHeight + Const.windowSize(2)/40;
        
        %Colors for the fuel gauge
        fuelGaugeFillColor = [1, .5, 0];
        fuelGaugeEdgeColor = [0, 0, 0];
        fuelGaugeLineWidth = 3;
        
        %% ROCKET CONSTANTS
        gravity = -9.806; %gravity, meters per second squared
        dryMass = 100000; %dry mass, kilograms
        fuelRate = 5000; %propellant burned per second at maximum throttle, kilograms per second
        maxThrust = 5000000; %maximum thrust, newtons
        maxPropMass = 360000; %maximum propellant mass, kilograms
        frictionMultiplier = 0.98; %velocity is multiplied by this each frame to approximate friction
        frameTime = 1 / 60; %seconds
        
        %% STARTING CONSTANTS
        startingPropMass = 360000; %default prop mass, kilograms
        %startingPropMass = 10000; %testing low fuel behavior
        startingPosition = Const.windowSize/2; %default position, m
        startingVelocity = [0,0]; %default velocity, m/s
        startingAltitude = 0; %default altitude, meters
        startingThrottle = 1; %default throttle, 0 to 1
        startingGameState = "title"; %title screen
        
        %% COW CONSTANTS
        cowPropMass = 1000; %mass of propellant given by cow, kilograms
        cowRandVals = [10, 30]; %minimum and maximum distance to next cow, meters
        propCowPity = 0.1; %value of the maximum fuel at which cow is force spawned
        cowSpawnMargin = 100; %distance from edge the cow should spawn, pixels
        cowSpawnY = 400; %distance from bottom of the screen the cow should spawn, pixels
        cowKillMargin = 400; %distance outside of the screen at which the cow should stop existing
        
        %% CONTROL CONSTANTS
        throttleInc = 1; %per second
        rotationInc = 180; %degrees per second
    end
end