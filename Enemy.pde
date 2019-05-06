
class Enemy extends Animatable implements Collidable {
    private  PImage sprite;
    private final int SIDE_LENGTH = 20;

    public Enemy(int lowTime, int highTime, AnimationQueue queue) {
        super(round(random(width)), -250, height + 500, round(random(lowTime, highTime)), queue);
        
        
        sprite = loadImage("enemy" + round(random(1, 5)) + ".png");//choose a random cloud image to laod
        sprite.resize(SIDE_LENGTH, SIDE_LENGTH);
    }

    public void display() {
        PVector currentPos = this.getCurrentPos();
        image(sprite, currentPos.x, currentPos.y);
        

        super.display(); //cleanup
    }

    public int getSideLength() {
        return SIDE_LENGTH;
    }

    
}