G = SpriteKit.Game.instance('Title', 'yo momma', 'Size', [690 420]);
bkg = SpriteKit.Background('Assets/background.png');
addBorders(G);



G.play(@action);

function action
    bkg.scroll('right', 5);
end
