
/**
*   Great for randomly generating clouds that fly down. 
*   Clouds are composed of a bunch of completely white circles thrown on top of each other
*   And then are slightly transparent to produce that cloud feeling. --- MAYBE
*   Will automatically despawn after reaching its destination (completely below the screen)
*/ 
class Cloud extends Animatable {

    private  PImage sprite;

    public Cloud(int lowTime, int highTime, AnimationQueue queue) {
        super(round(random(width)), -250, height + 500, round(random(lowTime, highTime)), queue);
        
        sprite = loadImage("cloud.png");//choose a random cloud image to laod
    }

    public void display() {
        PVector currentPos = this.getCurrentPos();
        image(sprite, currentPos.x, currentPos.y);
        

        super.display();
    }
    


}