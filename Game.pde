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
    private boolean haha = false;


    public Game (ScreenManager sm, PApplet gameObject) {
        super(sm, Game.uid);
        this.gameObject = gameObject;
    }

    public void init() {
        println("Lowering framerate");
        frameRate(10);
        println("Initializing Webcam and OpenCV... ");
        video = new Capture(gameObject, 640/2, 480/2);
        opencv = new OpenCV(gameObject, 640/2, 480/2);
        println("Loading the Haar Cascade...");
        opencv.loadCascade("haarcascade_frontalface_alt.xml", true);  
        println("Starting video... ");
        video.start();
    }

    
    void display() {
        
        image(video, 0, 0 );
        scale(-2, 2);
        opencv.loadImage(video);
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
                stroke(0,255,0);
                rect(-faces[i].x, faces[i].y, faces[i].width, faces[i].height);
                //let's say ship has hitbox of 100x100
                stroke(255,0 ,0 );
                prevx =faces[i].x + faces[i].width/2 - hitbox/2;
                prevy =  faces[i].y + faces[i].height/2 - hitbox/2;
                rect(-prevx, prevy, hitbox, hitbox);
                
            }

        }
        text(hitbox, 20, 20);
    }


    void captureEvent(Capture c) {
        c.read();
    }


    public void onClick(){

    }

    public void onType(){
        this.getScreenManager().setScreen("MainMenu");
    }
    
}