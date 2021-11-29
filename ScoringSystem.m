%Manages score counting
function scoringSystem(figure, rotation, altitude,gameState)

score = figure.UserData.score;
pos = figure.Position;


width = pos(3);
height = pos(4);


text(width/2, height/2, score)

end





