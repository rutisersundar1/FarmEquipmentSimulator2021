function SpriteKitTest

import SpriteKit.*

G = SpriteKit.Game.instance('Title', 'test', 'Size', [690 420]);

bkg = SpriteKit.Background('Assets/background.png');
bkg.Scale = 1.0;

s = SpriteKit.Sprite('rocket');

s.initState('rocket1', 'Assets/Rocket.png', true);
s.Location = [0,0];
s.State = 'rocket1';
s.Scale = 1;
iter = 1;

G.play(@action);

function action
    bkg.scroll('right',1);
    s.Location = s.Location + [1,1];
    s.Angle = s.Angle + 1;
    disp(iter);
    if iter == 360 
        G.stop
    end
    
    iter = iter + 1;
end

end