
class Enemy extends Animatable {
    private  PImage sprite;

    public Enemy(int lowTime, int highTime, AnimationQueue queue) {
        super(round(random(width)), -250, height + 500, round(random(lowTime, highTime)), queue);
        
        
        sprite = loadImage("enemy" + round(random(1, 5)) + ".png");//choose a random cloud image to laod
        sprite.resize(20,20);
    }

    public void display() {
        PVector currentPos = this.getCurrentPos();
        image(sprite, currentPos.x, currentPos.y);
        

        super.display(); //cleanup
    }
    
}