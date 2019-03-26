
/**
*   Great for randomly generating clouds that fly down. 
*   Clouds are composed of a bunch of completely white circles thrown on top of each other
*   And then are slightly transparent to produce that cloud feeling. --- MAYBE
*   Will automatically despawn after reaching its destination (completely below the screen)
*/ 
class Cloud extends Animatable {

    /**
    *   Instructions stored like following: [circ1x, circ1y, circ1radius, circ2x, circ2y, ... , circnradius]
    */
    private int[] instructions;

    private final static int sizeX = 150,
                    sizeY = 75,
                    minRad = 20,
                    maxRad = 50;

    public Cloud(int lowTime, int highTime, AnimationQueue queue) {
        super(round(random(width)), -250, height + 500, round(random(lowTime, highTime)), queue);

        instructions = new int[round(random(3, 10)) * 4];
        generate();
    }

    public void display() {
        PVector currentPos = this.getCurrentPos();
        noStroke();
        fill(0);
        try{
            for(int i = 0; i < instructions.length - 4; i += 4) {
                
                fill(230); //cloud color
                ellipse(instructions[i] + currentPos.x, instructions[i + 1] + currentPos.y, instructions[i + 2], instructions[i + 3]);
            }
        } catch (Exception e) {
            println("array thing for cloud messed up");
        }
        rect(currentPos.x, currentPos.y, 20, 20);

        super.display();
    }
    
    /**
    * Generate a new cloud. 
    * Needs changing to make the cloud shapes more natural/all the cloud pieces actually contact each other.
    * Otherwise, consider also switching it out for using pregenerated images.
    */
    public void generate(){
        for(int i = 0; i < instructions.length - 3; i += 3) {
            instructions[i] = round(random(sizeX));
            instructions[i + 1] = round(random(sizeY));
            instructions[i + 2] = round(random(minRad, maxRad));
            instructions[i + 3] = round(random(minRad, maxRad));
        }
    }



}