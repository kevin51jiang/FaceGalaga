
class Spaceship extends Animatable {

    private static final int timePerAnim = 4000;
    private static final int mobilityX = 20, mobilityY = 35;
    private PShape drawing = loadShape("./spaceship.svg");
    private PVector modifier = new PVector(0, 0);
    
    public Spaceship(AnimationQueue queue){
        super(new PVector(width / 2 - sqrt(2 * sq(height / 2.5)) / 2, height / 2 ), 
            new PVector(width / 2 - (sqrt(2 * sq(height / 2.5)) / 2) + (random(mobilityX) - mobilityX / 2), 
                        height / 2 + random(mobilityY) - mobilityY / 2),
            timePerAnim,
            queue);

        imageMode(CENTER);
      //  drawing.rotateZ(TAU * 7.0/8.0);
    }

    public void display() {
        PVector temp = this.getCurrentPos();

        if(frameCount % timeToFrames(1000) == 0) {
            modifier = new PVector( random(3.0) - 1.5, random(3.0) - 1.5);
        }
    
        //TODO: ALLOW ARROW KEYS TO CONTROL THE ROCKETSHIP'S ROTATION
        // drawing.rotate(radians(random(0.25)-0.125));//rotate the rocketship a tiny bit each frame
        
        shape(drawing, temp.x + modifier.x, temp.y + modifier.y, height / 2.5, height / 2.5);//tiny little movements to simulate how a rocket is unstable
        
        // FOR DEBUG
        // pushStyle(); 
        //     stroke(5);
        //     fill(255,255,0);
        //     point(temp.x + modifier.x, temp.y + modifier.y);//DEBUG
        //     rect(temp.x + modifier.x, temp.y + modifier.y, 3, 3);
        // popStyle();
        
        super.display();//cleanup

        //tries to add itself back with a new animation
        if(!this.isInAnimation()) {
            // this.addAnimation(new PVector(width / 2 + random(mobilityX) - mobilityX / 2, height / 2 + random(mobilitY) - mobilitY / 2 ),
            //                 timePerAnim,
            //                 queue);
            this.addDeltaAnimation(new PVector(random(mobilityX) - mobilityX / 2, random(mobilityY) - mobilityY / 2),
                                timePerAnim,
                                queue);
            queue.add(this);
        }
    }
}
