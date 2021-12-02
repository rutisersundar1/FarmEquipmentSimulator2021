%Handles rotation inputs and constrains rotation between zero and 360
%degrees. Takes in the rocket Sprite it is going to be acting on.
function calcRotation(rocket)
    %Handle rotation inputs. Right is d and left is a.
    switch(rocket.rotBuffer)
        case 2 %d key, rotate right
            rotationVal = rocket.Angle - Const.rotationInc * Const.frameTime;
        case 1 %a key, rotate left
            rotationVal = rocket.Angle + Const.rotationInc * Const.frameTime;
            %fprintf("rotating left, rotation is now %f deg\n", rotation);
        otherwise
            rotationVal = rocket.Angle;
    end

    %Constrain rotation between 0 and 360 by adding or subtracting 360.
    while rotationVal >= 360
        rotationVal = rotationVal - 360;
    end

    while rotationVal < 0
        rotationVal = rotationVal + 360;
    end

    %Assign the working value to the output.
    rocket.Angle = rotationVal;
    rocket.rotBuffer = 0; %clear rotation buffer
end