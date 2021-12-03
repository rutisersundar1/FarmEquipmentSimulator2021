%Creates a cow Sprite from the Constants provided.
function cow = createCow()
    cow = SpriteKit.Sprite('cow');

    %Set up state
    cow.initState('on', Const.cowImg, true);
    cow.initState('off', Const.noneImg, true); %when the cow has been collected, this allows it to disappear
    cow.initState('fly', Const.cowFlyImg, true); %flying cows!

    %Give it its properties
    addprop(cow, 'propAmt'); %amount of propellant in the cow, kg
    addprop(cow, 'xToNextCow'); %distance until next cow, meters
    cow.State = 'off'; %Disable the cow to start
    cow.Scale = Const.cowScale; %set the scale of the sprite (shouldn't really be needed)

    cow.propAmt = Const.cowPropMass; %Amount of propellant in the cow
    cow.xToNextCow = randi(Const.cowRandVals); %meters since last cow collected
end