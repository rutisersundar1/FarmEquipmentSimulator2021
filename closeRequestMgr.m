%To be called on the window's close request.
function closeRequestMgr(source, event)
    %Display user score
    fprintf('You scored %i points!\n', source.UserData.score);
    
    %Game state -1 = close
    source.UserData.gameState = -1;
end