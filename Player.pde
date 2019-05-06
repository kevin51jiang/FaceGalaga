class Player extends Animatable implements Collidable {
    final static int MAX_MOVING_TIME = 200; //the maximum amount of time that it will take the ship to move to a new position in ms
    final static int LARGE_AMOUNT_OF_TIME = 100000;
    private PImage sprite;
    private final int SIDE_LENGTH = 20;
    
    public Player(PVector currentPos, AnimationQueue queue) {
        super(currentPos, currentPos, LARGE_AMOUNT_OF_TIME, queue);
        
        
        sprite = loadImage("player.png");//choose a random cloud image to laod
        sprite.resize(SIDE_LENGTH, SIDE_LENGTH);
    }

    public PImage getSprite() {
        return sprite;
    }

    public void display() {
        PVector currentPos = this.getCurrentPos();
        image(sprite, currentPos.x + 10, currentPos.y + 10);
        
        // if(frameCount % 3 == 0) {
        //     println("Player: " + currentPos.x + ", " + currentPos.y);
        // }

        
        super.display(); //cleanup

        //keep it persisitent 
        //tries to add itself back with a new animation
        if(!this.isInAnimation()) {
            this.addDeltaAnimation(new PVector(0, 0), //don't want it moving anywhere if it's already in the palyers' sdesired psot
                                LARGE_AMOUNT_OF_TIME,
                                queue);
            queue.add(this);
        }

    }

    public void updatePos(int x, int y) {
        PVector dest = new PVector(x, y);
        this.addAnimation(dest, MAX_MOVING_TIME, queue);
    }

    public int getSideLength() {
        return SIDE_LENGTH;
    } 

    public boolean isCollidingWith(Collidable c) {
        PVector cPos = c.getCurrentPos();
        int cSideLen = c.getSideLength();

        // 2 rectangle collision detection
        // https://developer.mozilla.org/en-US/docs/Games/Techniques/2D_collision_detection
        if(current.x < cPos.x + cSideLen &&
                current.x + this.SIDE_LENGTH > cPos.x &&
                current.y < cPos.y + cSideLen &&
                current.y + this.SIDE_LENGTH > cPos.y) {

            return true;    
        } else {
            return false;
        }
    }
    
}