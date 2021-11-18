%Handles rotation inputs and constrains rotation between zero and 360
%degrees.
function rotationOut = calcRotation(rotInput, rotation, rotationInc, frameTime)
    %Handle rotation inputs. Right is d and left is a.
    switch(rotInput)
        case 2 %d key, rotate right
            rotationVal = rotation + rotationInc * frameTime;
        case 1 %a key, rotate left
            rotationVal = rotation - rotationInc * frameTime;
            fprintf("rotating left, rotation is now %f deg\n", rotation);
        otherwise
            rotationVal = rotation;

    end

    %Constrain rotation between 0 and 360 by adding or subtracting 360.
    while rotationVal >= 360
        rotationVal = rotationVal - 360;
    end

    while rotationVal < 0
        rotationVal = rotationVal + 360;
    end

    %Assign the working value to the output.
    rotationOut = rotationVal;
end