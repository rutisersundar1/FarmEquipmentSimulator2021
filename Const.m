%Stores constant values that need to be accessed from many locations. This
%allows us to not need to pass each of these into each function, or worse,
%hard-code them. Most functions reference this when a value that doesn't change
%is needed.
classdef Const
    properties (Constant)
        %% DEBUG
        %For making stuff make sense.
        debugTextX = 100;
        debugTextY = 100;
        
        debugShowRocketPos = 0; %shows rocket position
        debugShowCowPos = 0; %show cow position
        debugShowGameState = 0; %show game state
        
        debugForceSpawnCow = 0; %Debug key forces a cow to spawn
        
        debugBlueScreenBG = 0; %bluescreen background for easier graphics
        debugHideUI = 0; %hide the UI (gauges, altimeter, score). Does not apply when paused.
        
        %% DISPLAY CONSTANTS
        %Scale values should not be changed from 1, as it has a significant
        %performance impact.
        blueScreenBGImg = 'Assets/backgroundBlueScreen.png'; %bluescreen image
        backgroundImg = 'Assets/background.png'; %Path to the background image
        backgroundScale = 1; %Do not change scale values.
        
        rocketImg = 'Assets/rocket3.png'; %Path to the rocket image
        rocketScale = 1; %Do not change scale values.
        
        crashedRocketImg = 'Assets/rocket3_crashed.png'; %Crashed version of the rocket
        
        %Low/mid/high thrust images (with flames)
        rocketThrust1Img = 'Assets/rocket3_low.png';
        rocketThrust2Img = 'Assets/rocket3_mid.png';
        rocketThrust3Img = 'Assets/rocket3_high.png';
        
        exhaustImg = 'Assets/exhaust.png'; %exhaust particle

        cowImg = 'Assets/cow.png'; %Path to the cow image
        cowScale = 1; %Do not change scale values.
        noneImg = 'Assets/noneImg.png'; %1x1 transparent png.
        cowFlyImg = 'Assets/cowFly.png'; %flying cow image

        titleScreenImg = 'Assets/titleScreen.png'; %Title screen
        pauseScreenImg = 'Assets/pauseScreen.png'; %Pause screen
        crashScreenImg = 'Assets/crashScreen.png'; %Crash screen
        
        tutorial1Img = 'Assets/tutorial.png'; %Tutorial screen

        windowSize = [1280 720]; %Window size, pixels.
        
        %This controls how fast things appear to move (how far a sprite is
        %moved when its position changes by one meter)
        pixelsPerMeter = Const.windowSize(1) * 50/1280;
        
        zeroAlt = 80; %pixels
        
        backgroundVerticalScroll = 0; %Whether or not to scroll the backround up and down

        %% FUEL GAUGE CONSTANTS
        
        fuelGaugeWidth = Const.windowSize(1) * 50/1280
        fuelGaugeMaxHeight = Const.windowSize(2) / 2;
        fuelGaugeOffset = [ 50/1280 * Const.windowSize(2), Const.windowSize(2) / 5];
        
        %X and Y coordinates of the fuel gauge's text label
        fuelTextX = Const.fuelGaugeOffset(1) + Const.fuelGaugeWidth/5;
        fuelTextY = Const.fuelGaugeOffset(2) + Const.fuelGaugeMaxHeight + Const.windowSize(2)/40;
        
        %Colors for the fuel gauge
        fuelGaugeFillColor = [1, .5, 0];
        fuelGaugeEdgeColor = [0, 0, 0];
        fuelGaugeLineWidth = 3;
        
        altTextX = Const.windowSize(1)/2 - 60 %altitude text x coord
        altTextY = Const.windowSize(2) - 40; %altitude text y coord
        
        scoreTextX = Const.windowSize(1) - 300; %Score text x coord
        scoreTextY = Const.windowSize(2) - 40; %Score text y coord
        
        %Throttle gauge constants
        %How far off the bottom of the screen the throttle gauge is
        throtGaugeOffsetY = Const.windowSize(2) / 30;
        throtGaugeHeight = Const.windowSize(2) * 20/720;
        %How wide the throttle gauge is
        throtGaugeWidth = Const.windowSize(1) / 2;
        %Left side of the throttle gauge
        throtGaugeLeftX = Const.windowSize(1)/2 - Const.throtGaugeWidth/2;
        %Right side of the throttle gauge
        throtGaugeRightX = Const.windowSize(1)/2 + Const.throtGaugeWidth/2;
        
        %Throttle gauge Position vector
        throtGaugeRectPos = [Const.throtGaugeLeftX, Const.throtGaugeOffsetY,...
            Const.throtGaugeWidth, Const.throtGaugeHeight];
        
        %Colors of the throttle gauge
        throtGaugeFillColor = [1, 0, 0];
        throtGaugeEdgeColor = [0, 0, 0];
        throtGaugeLineWidth = 3;
        
        throtTextMargin = Const.windowSize(2) * 10/720
        throtTextX = Const.throtGaugeRightX + Const.throtTextMargin;
        throtTextY = Const.throtGaugeOffsetY + Const.throtGaugeHeight / 2;
        
        %% ROCKET CONSTANTS
        gravity = -9.806; %gravity, meters per second squared
        dryMass = 100000; %dry mass, kilograms
        fuelRate = 5000; %propellant burned per second at maximum throttle, kilograms per second
        maxThrust = 5000000; %maximum thrust, newtons
        maxPropMass = 360000; %maximum propellant mass, kilograms
        frictionMultiplier = 0.99; %velocity is multiplied by this each frame to approximate friction
        frameTime = 1 / 60; %seconds
        
        %Throttle cutoffs: Below these values, the rocket will appear to
        %have a different size of flame (if it has propellant).
        throttle2cutoff = 0.8; %Mid throttle
        throttle1cutoff = 0.5; %Low throttle
        throttle0cutoff = 0.1; %Zero throttle
        
        %% STARTING CONSTANTS
        startingAngle = 0; %default angle, degrees
        startingPropMass = 360000; %default prop mass, kilograms
        %startingPropMass = 50000; %for testing low fuel behavior
        %This is the middle of the screen by default, but could be changed
        %if you wanted.
        startingPosition = Const.windowSize/2; %default position, m
        startingVelocity = [0,0]; %default velocity, m/s
        startingAltitude = 5; %default altitude, meters
        %Start at full throttle so that we don't dump the player into the
        %ground and crash instantly.
        startingThrottle = 1; %default throttle, 0 to 1
        startingGameState = "title"; %title screen
        restartGameState = "title"; %game state if restarting from crash
        
        %% COW CONSTANTS
        cowPropMass = 30000; %mass of propellant given by cow, kilograms
        cowRandVals = [10, 60]; %minimum and maximum distance to next cow, meters
        propCowPity = 0.1; %value of the maximum fuel at which cow is force spawned
        cowSpawnMargin = 100; %distance from edge the cow should spawn, pixels

        %This value is negative because the cow needs to appear like its
        %feet are on the ground. If it were zero, the cow looks like it's
        %floating.
        cowSpawnAlt = -0.5; %Altitude over the ground to spawn the cow, meters
        cowKillMargin = 400; %distance outside of the screen at which the cow should be set to invisible and intangible
        cowFlyChance = 0.2; %chance for the cow to be flying. 0.2 = 20%

        cowFlyRandAlts = [2, 10]; %random altitudes for flying cows to spawn!
        cowFlyPropMass = 45000; %mass of propellant for flying cows, kg

        %cowSpawnY = 0; %spawn y in pixels for old spawn behavior. no longer used
        
        %% PARTICLE CONSTANTS

        numParticles = 10;

        defaultParticlePos = [0,0];

        %Distance to offset the particle spawns from the rocket's location
        particleOffsetDist = 20; %pixels
        %Starting velocity when at max throttle
        particleMaxVelocity = 10; %meters per second
        particleVelocityMultiplier = 1; %Multiplies the particle's velocity

        particleMaxAge = 30; %frames
        %When a particle is despawned, its age is set to a very high
        %number. This way, when looking for a slot to spawn a new particle
        %in, this particle will be selected.
        particleDespawnedAge = 9999; %Indicates a particle as despawned.
        
        %% SCORING CONSTANTS
        altitudeScoreCutoff = 5; %If below this altitude, score is counted
        angleMultiplier = 1; %Multiplier for angle scoring
        altitudeMultiplier = 1; %Multiplier for altitude scoring
        
        %% CONTROL CONSTANTS
        throttleInc = 1; %per second. 1 means that it goes from zero to full throttle within one second.
        rotationInc = 180; %degrees per second
    end
end