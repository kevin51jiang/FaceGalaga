import gab.opencv.*;
import processing.video.*;
import java.awt.*;

class Game extends Screen {
    PApplet gameObject;
    Capture video;
    OpenCV opencv;

    int hitbox = 25;

    String accum = "";
    int prevx = 0, prevy = 0;

    private static final String uid = "Game";
    int ayahFactor = 0    ;
    int vertFactor = 0;

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
            println(faces.length);


            if(faces.length == 0) {
                rect(prevx, prevy, hitbox, hitbox);
            } else {
                
                for (int i = 0; i < faces.length; i++) {
                    println(faces[i].x + "," + faces[i].y);
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
    }
    
}