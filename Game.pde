import gab.opencv.*;
import processing.video.*;
import java.awt.*;
import static javax.swing.JOptionPane.*;

class Game extends Screen {

    AnimationQueue queue = new AnimationQueue();
    PApplet gameObject;
    Capture video;
    OpenCV opencv;

    int hitbox = 20;

    String accum = "";
    int prevx, prevy;
    Player player;

    private static final String uid = "Game";
    

    public Game (ScreenManager sm, PApplet gameObject, Capture video, OpenCV opencv) {
        super(sm, Game.uid);
        this.gameObject = gameObject;
        this.video = video;
        this.opencv = opencv;
        
    }

    public void init() {
        println("Lowering framerate");
        frameRate(30);

        println("Loading the Haar Cascade...");
        // opencv.loadCascade("haarcascade_frontalface_alt.xml", true);  
        opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE); 

        println("Starting video... ");
        video.start();
        player = new Player(new PVector(width / 2, height / 2), queue);
    }

    
    void display() {
        background(0);
        
        scale(2);
        image(video, 160, 120 ); //translate the image to make up for weird webcam stuff
        if(frameCount % 4 <= 3) { //only process every 3/4 frames. Keep video on to make it seem smooth
            opencv.loadImage(video);
            //detect the faces
            noFill();
            stroke(0, 255, 0);
            strokeWeight(3);
            Rectangle[] faces = opencv.detect();
            // println(faces.length);


            if(faces.length == 0) {
                rect(prevx, prevy, hitbox, hitbox);
            } else {
                
                for (int i = 0; i < faces.length; i++) {
                    // println(faces[i].x + "," + faces[i].y);
                    //let's say ship has hitbox of 100x100
                    stroke(255,0 ,0 );
                    prevx = faces[i].x + faces[i].width/2 - hitbox/2;
                    prevy = faces[i].y + faces[i].height/2 - hitbox/2;
                    rect(prevx, prevy, hitbox, hitbox);
                    
                }

            }
            
        } else {
            pushMatrix();
            stroke(255,0,0);
            rect(prevx, prevy, hitbox, hitbox);
            popMatrix();
        }

     

        //keep the player's position updated
        
        if(frameCount % 4 == 0) {
            player.updatePos(prevx, prevy);
            println(prevx + ", " + prevy);
        }
        player.display();

        //generate new enemies and stuff
        if(timeToFrames(200) != 0 && //prevent divide by zero errors
            frameCount % timeToFrames(200) == 0){    //MAYBE spawn clouds
            if(random(100) < 75) { //25% every half second will spawn a cloud
                Enemy e = new Enemy(4000, 8000, queue);
                queue.add(e);
            }
        }
        

        
        //do collision


        queue.display();

    }


    void captureEvent(Capture c) {
        c.read();
    }


    public void onClick(){

    }

    public void onType(){
        // this.getScreenManager().setScreen("MainMenu");
        // if(keyCode == LEFT) {
        //     ayahFactor -= 10;
        // } else if(keyCode == RIGHT) {
        //     ayahFactor += 10;
        // } else if(keyCode == UP) {
        //     vertFactor -= 10;
        // } else if(keyCode == DOWN) {
        //     vertFactor += 10;
        // } 
        // println(ayahFactor + ", " + vertFactor);
    
        // if(keyCode == ESC ) {
        //     int dialogResult = JOptionPane.showConfirmDialog (null, "Do you want to exit to the main menu?","Warning", JOptionPane.YES_NO_OPTION);
        //     if(dialogResult == JOptionPane.YES_OPTION){
        //         this.getScreenManager().setScreen("MainMenu");
        //         sm.display();
        //         print("Done setting");
        //     } else {
        //         print("owo it's a no");
        //         sm.display();
        //     }
        // }
        if(keyCode == ESC) {
            println("ESC key hit. Exiting now.");
            System.exit(0);
        }
    }
    
}