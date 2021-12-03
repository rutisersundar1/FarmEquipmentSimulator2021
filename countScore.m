%Manages score counting
function countScore(rocket)

%If rocket is below scoring threshold, count score
if (rocket.altitude < Const.altitudeScoreCutoff)
    %Score due to angle (flatter is better)
    angleScoreAdd = cosd(rocket.Angle) * (Const.angleMultiplier);
    %Score due to altitude (lower is better)
    altScoreAdd = (Const.altitudeScoreCutoff - rocket.altitude) * (Const.altitudeMultiplier);
    %Add to rocket score
    rocket.score = rocket.score + angleScoreAdd + altScoreAdd;
end

end





