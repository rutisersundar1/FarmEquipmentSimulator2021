%Sets up and returns a Sprite object for the rocket.
function rocket = createRocket(Const)
    %Create rocket Sprite object
    rocket = SpriteKit.Sprite('rocket');

    %Set up the default state for the rocket and give it its image
    rocket.initState('rocket1', Const.rocketImg, true);
    rocket.initState('hide', Const.noneImg, true); %hide rocket if needed
    %rocket.initState('crash', Const.crashImg, true); %exploded rocket
    
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
    addprop(rocket, 'specialBuffer'); %key buffer for pause, etc. keys
    addprop(rocket, 'gameState'); %game state: "play" "pause" "crash" "title"
    addprop(rocket, 'zeroAltLocPx'); %zero altitude location in pixels
    addprop(rocket, 'score'); %game score
    
    %Initialize rocket physics and give it its values
    rocket.Location = Const.startingPosition;
    rocket.velocity = Const.startingVelocity;
    rocket.State = 'rocket1';
    rocket.Scale = Const.rocketScale;
    rocket.altitude = Const.startingAltitude;
    rocket.propMass = Const.startingPropMass;
    rocket.dryMass = Const.dryMass;
    rocket.mass = Const.startingPropMass + Const.dryMass;
    rocket.fuelRate = Const.fuelRate;
    rocket.maxThrust = Const.maxThrust;
    rocket.throttle = Const.startingThrottle;
    rocket.maxPropMass = Const.maxPropMass;
    rocket.gameState = Const.startingGameState;
    rocket.zeroAltLocPx = rocket.Location(2) - rocket.altitude * Const.pixelsPerMeter; 

    %These need to be initialized to 0 (empty)
    rocket.throttleBuffer = 0;
    rocket.rotBuffer = 0;
    rocket.specialBuffer = 0;
end