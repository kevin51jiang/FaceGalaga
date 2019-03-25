/**
*   Everything that has to do with the main menu
*/
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
        //println("Framecount: " + frameCount);
        if(frameCount != 0 ) {
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
