%Manages score counting
function scoringSystem(rocket)

rocket.altitude
rocket.Angle
rocket.score
Const.angleMultiplier
Const.altitudeScoreCutoff
Const.altitudeMultiplier




rocketScoreAdd = ((cosd(rocket.Angle))*Const.angleMultiplier) + (rocket.altitude * Const.altitudeMultiplier)

if (rocket.altitude < Const.altitudeScoreCutoff)
    
    rocket.score = rocket.score + rocketScoreAdd


end





