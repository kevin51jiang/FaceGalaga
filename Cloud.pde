
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
    private Integer[] instructions;

    private final static int sizeX = 150,
                    sizeY = 75,
                    minRad = 20,
                    maxRad = 50;

    public Cloud(int lowTime, int highTime, AnimationQueue queue) {
        super(round(random(width)), -250, height + 500, round(random(lowTime, highTime)), queue);

        final int BRANCHES = round(random(3)) + 3; //between 3 and 6 branches
        final int DEPTH = round(random(2, 5)); // each branch has a depth between 2 and 5

        instructions = new Integer[(BRANCHES * DEPTH * 3) + 3];
        generate(BRANCHES, DEPTH);
    }

    public void display() {
        PVector currentPos = this.getCurrentPos();
        noStroke();
        fill(0);
        try{
            for(int i = 0; i < instructions.length - 4; i += 4) {
                
                fill(230); //cloud color
                
                ellipse(instructions[i] + currentPos.x, //x coord
                        instructions[i + 1] + currentPos.y, // y coord
                        instructions[i + 2], // width
                        instructions[i + 2]); // height
            }
        } catch (Exception e) {
            println("array thing for cloud messed up");
        }
        

        super.display();
    }
    
    /**
    * Generate a new cloud. 
    * Needs changing to make the cloud shapes more natural/all the cloud pieces actually contact each other.
    * Otherwise, consider also switching it out for using pregenerated images.
    */
    public void generate(int branches, int depth){
        //generate the root node
        instructions[0] = 0;
        instructions[1] = 0;
        instructions[2] = round(random(minRad, maxRad));

        for (int i = 0; i < branches; ++i) {
            int prevx = instructions[0],
                prevy = instructions[1],
                prevRad = instructions[2];

            for(int j = 0; j < depth; ++j) {
                final int depthStartIndex = 3 * i * depth + 3 * j + 3;
                final float constantThing = 1.0 / sqrt(2);
                instructions[depthStartIndex] = round(random(-prevRad * constantThing, prevRad * constantThing)) + prevx; //x coord
                instructions[depthStartIndex + 1] = round(random(-prevRad * constantThing, prevRad * constantThing)) + prevy; //y coord
                instructions[depthStartIndex + 2] = round(random(minRad, maxRad)); // radius

                prevx = instructions[depthStartIndex];
                prevy = instructions[depthStartIndex + 1];
                prevRad = instructions[depthStartIndex + 2];
            }
        }

        //DEBUG
        println("Generated cloud: " + Arrays.deepToString(instructions));
    }



}