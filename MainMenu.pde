
class MainMenu extends Screen {
    //config
    private final static String uid = "MainMenu";
    // private PShape spaceship = loadShape("./spaceship.svg");;
    private final PFont titleFont = createFont("Rajdhani-Regular.ttf", 96);
    private final PVector buttonDimensions = new PVector(width / 25, width/25);
    
    AnimationQueue queue = new AnimationQueue();
    private final color darksky = color(0, 0, 20);
    private final color medSky = color(0, 75, 127);
    private final color lightsky = color(7, 150, 255);
    private final float percentDark = 0.7;
    
    private Button btnVolume, btnTutorial;
    private final Spaceship spaceship;

    public MainMenu(ScreenManager sm) { 
        super(sm, MainMenu.uid);

        try {
            btnVolume = new Button(new PVector(20, 20), buttonDimensions );
            btnTutorial = new Button(new PVector(buttonDimensions.x + 40, 20 ), buttonDimensions);
        } catch (Exception e){
            e.printStackTrace();
        }
        spaceship = new Spaceship(queue);
        
        queue.add(spaceship);
    }

    public void init() {
        
    }

    public void display() {

        //Background
        noFill();
        for (int i = 0; i <= height; i++) {
            float inter = map(i, 0, height, 0, 1);
            color c = lerpColor(darksky, medSky, inter);
            stroke(c);
            line(0, i, width, i);
        }

      
        //clouds back
        if(frameCount != 0 && //prevent divide by zero errors
            frameCount % timeToFrames(500) == 0){    //MAYBE spawn clouds
            if(random(100) < 65) { //25% every half second will spawn a cloud
                Cloud c = new Cloud(3000, 8000, queue);

                queue.add(c);
            }
        }

        //spaceship display
        queue.display();


        //clouds front
        if(frameCount != 0 &&
            frameCount % timeToFrames(250) == 0){    //MAYBE spawn clouds
            if(random(100) < 65) { //25% every half second will spawn a cloud
                Cloud c = new Cloud(3000, 8000, queue);

                queue.add(c);
            }
        }




        //Title
        noStroke();
        fill(255);
        textFont(titleFont,80);
        textAlign(CENTER, CENTER);
        text("Rocket", width / 2, height / 6);

        //volume button
        fill(255, 0, 0);
        rect(btnVolume.corner1.x, btnVolume.corner1.y, buttonDimensions.x, buttonDimensions.y);

        //tutorial button
        fill(0, 255, 0);
        rect(btnTutorial.corner1.x, btnTutorial.corner1.y, buttonDimensions.x, buttonDimensions.y);


    }

    public void onClick() {
        if(btnTutorial.isClicked()) {
            println("Tutorial got clicked");
        } else if (btnVolume.isClicked()) {
            println("Volume got clicked");
        }
    }

    public void onType() {
        if(keyCode == ENTER){
          //  scrnMgr.setScreen("game");
        //   println("Main menu recieved [ENTER]");
            this.getScreenManager().setScreen("Game");

        }
    }
}

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
        drawing.rotate(TAU * 7.0/8.0);
    }

    public void display() {
        PVector temp = this.getCurrentPos();

        if(frameCount % timeToFrames(1000) == 0) {
            modifier = new PVector( random(3.0) - 1.5, random(3.0) - 1.5);
        }
    
        //TODO: ALLOW ARROW KEYS TO CONTROL THE ROCKETSHIP'S ROTATION
        drawing.rotate(radians(random(0.25)-0.125));//rotate the rocketship a tiny bit each frame
        
        shape(drawing, temp.x + modifier.x, temp.y + modifier.y, height / 2.5, height / 2.5);//tiny little movements to simulate how a rocket is unstable
        
        pushStyle();
            stroke(5);
            fill(255,255,0);
            point(temp.x + modifier.x, temp.y + modifier.y);//DEBUG
            rect(temp.x + modifier.x, temp.y + modifier.y, 3, 3);
        popStyle();
        
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
                fill(255);
                ellipse(instructions[i] + currentPos.x, instructions[i + 1] + currentPos.y, instructions[i + 2], instructions[i + 3]);
            }
        } catch (Exception e) {
            println("array thing for cloud messed up");
        }
        rect(currentPos.x, currentPos.y, 20, 20);

        super.display();
    }

    public void generate(){
        for(int i = 0; i < instructions.length - 3; i += 3) {
            instructions[i] = round(random(sizeX));
            instructions[i + 1] = round(random(sizeY));
            instructions[i + 2] = round(random(minRad, maxRad));
            instructions[i + 3] = round(random(minRad, maxRad));
        }
    }


}