import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import gab.opencv.*; 
import java.util.*; 
import processing.video.*; 
import gab.opencv.*; 
import processing.video.*; 
import java.awt.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class ProcessingIsBad extends PApplet {






ScreenManager sm;

final int opencvRefreshes = 4; //number of times opencv tries to detect faces per second
                                // intentionally can skip some frames to increase the performance of the game

public void setup() {
    frameRate(60);
    
    sm = new ScreenManager();
    sm.init(new MainMenu(sm));
    sm.add(new Game(sm, this));
    stroke(0);
}

public void draw() {
    sm.display();

    // if(frameCount%240 == 0) {
    //     println("Screens included: "+Arrays.deepToString(sm.screens.values().toArray()));
    // }

    
} 

public void mousePressed(){
    sm.onClick();
}

public void keyPressed() {
    sm.onType();
}


public int timeToFrames(int time) {
    return round(frameRate / 1000.0f * time);
}

class AnimationQueue {
    private ArrayList<Animatable> currentAnimations = new ArrayList<Animatable>();
    public AnimationQueue() {}

    public void add(Animatable anim){
        currentAnimations.add(anim);
    }

    public void remove(Animatable anim){
        currentAnimations.remove(anim);
    }

    public void display() {
        for(int i = 0; i < currentAnimations.size(); i++){
            currentAnimations.get(i).display();
        }
    }

}

/**
* Class that implements linear animations ----- may switch towards eased in/out animations in the future
*/
abstract class Animatable {
    PVector start, current, dest;
    AnimationQueue queue;
    private float framesLeft, framesMax;
    
    /**
    *   Time is in milliseconds
    */
    public Animatable(PVector start, PVector dest, int time, AnimationQueue queue){
        this.current = start;
        this.addAnimation(dest, time, queue);
    }

    /**
    *   Made specifically for objects that start at the top and
    *   go completely vertical down until they despawn.
    */
    public Animatable(int x, int y, int deltaY, int time, AnimationQueue queue) {
        this.current = new PVector(x, y);
        PVector dest = new PVector(x, y + deltaY);
        this.addAnimation(dest, time, queue);
    }

    public Animatable(PVector start) {
        this.start = start;
        this.current = start;
        this.dest = start;
        framesLeft = 0;
        framesMax = 0;
    }


    /*
    *   Subclasses will ALWAYS call super.display() at the end of their display() methods to help with cleanup.
    */
    public void display() {
        this.framesLeft--;

        //if it has no frames left, remove it from the queue and it will stop being displayed
        if(framesLeft <= 0){//do less than instead of == because floats are weird
            queue.remove(this);
        }
    }

    public void addAnimation(PVector dest, int time, AnimationQueue queue){
        this.start = current;
        this.dest = dest;

        this.framesMax = timeToFrames(time);
        this.framesLeft = framesMax;

        this.queue = queue;

        // println("added anim: " + start.x + ", " + start.y + " - " + dest.x + ", " + dest.y);
    }

    public void addDeltaAnimation(PVector delta, int time, AnimationQueue queue){
        this.start = current;
        this.dest = new PVector(current.x + delta.x, current.y + delta.y);

        this.framesMax = timeToFrames(time);
        this.framesLeft = framesMax;

        this.queue = queue;

        println("added anim: " + start.x + ", " + start.y + " - " + dest.x + ", " + dest.y);

    }

    /*
    *   If ever implement a bezier ease in/out system, this is the method that needs changing.
    */
    public PVector getCurrentPos() {


        current = PVector.lerp(dest, start, framesLeft / framesMax);
        //println("Current pos: " + current.x + ", " + current.y + " lerp%= " + framesLeft/framesMax * 100);
        return current;
    }
        
    public boolean isInAnimation() {
        return framesLeft > 0;
    }

    

}






class Button {

    public PVector corner1, corner2;

    public Button (PVector origin, PVector dimensions) throws Exception{
        this.corner1 = origin;
        this.corner2 = new PVector(origin.x + dimensions.x, origin.y + dimensions.y);

        
        if(dimensions.x < 1 || dimensions.y < 1) {
            throw new Exception("Width and height of a button must be positive");
        }
    }

    public Button (PVector origin, int wide, int high) throws Exception {
        this.corner1 = origin;
        this.corner2 = new PVector(origin.x + wide, origin.y + high);

        
        if(wide <1 || high < 1) {
            throw new Exception("Width and height of a button must be positive");
        }
    }

    public Button (int x, int y, int wide, int high) throws Exception {
        this.corner1 = new PVector(x, y);
        this.corner2 = new PVector(x + wide,  y + high);

        if(wide <1 || high < 1) {
            throw new Exception("Width and height of a button must be positive");
        }
    }

    public String toString(){
        return "C1: " + corner1.x + ", " + corner1.y + "\n"
                +"C2: " + corner2.y + ", " + corner2.y + "\n";
    }

    public boolean isClicked(){

        if(mouseX > corner1.x && mouseX < corner2.x
            && mouseY >corner1.y &&  mouseY < corner2.y ){
                return true;
        } else {
            return false;
        }
    }

}




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

    
    public void display() {
        
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


    public void captureEvent(Capture c) {
        c.read();
    }


    public void onClick(){

    }

    public void onType(){
        this.getScreenManager().setScreen("MainMenu");
    }
    
}

class MainMenu extends Screen {
    //config
    private final static String uid = "MainMenu";
    // private PShape spaceship = loadShape("./spaceship.svg");;
    private final PFont titleFont = createFont("Rajdhani-Regular.ttf", 96);
    private final PVector buttonDimensions = new PVector(width / 25, width/25);
    
    AnimationQueue queue = new AnimationQueue();
    private final int darksky = color(0, 0, 20);
    private final int medSky = color(0, 75, 127);
    private final int lightsky = color(7, 150, 255);
    private final float percentDark = 0.7f;
    
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
            int c = lerpColor(darksky, medSky, inter);
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
        super(new PVector(width / 2 - sqrt(2 * sq(height / 2.5f)) / 2, height / 2 ), 
            new PVector(width / 2 - (sqrt(2 * sq(height / 2.5f)) / 2) + (random(mobilityX) - mobilityX / 2), 
                        height / 2 + random(mobilityY) - mobilityY / 2),
            timePerAnim,
            queue);

        imageMode(CENTER);
        drawing.rotate(TAU * 7.0f/8.0f);
    }

    public void display() {
        PVector temp = this.getCurrentPos();

        if(frameCount % timeToFrames(1000) == 0) {
            modifier = new PVector( random(3.0f) - 1.5f, random(3.0f) - 1.5f);
        }
    
        //TODO: ALLOW ARROW KEYS TO CONTROL THE ROCKETSHIP'S ROTATION
        drawing.rotate(radians(random(0.25f)-0.125f));//rotate the rocketship a tiny bit each frame
        
        shape(drawing, temp.x + modifier.x, temp.y + modifier.y, height / 2.5f, height / 2.5f);//tiny little movements to simulate how a rocket is unstable
        
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
/**
* Generic Screen object. Handles all the internal logic / displaying by itself.
* Used for big chunks of the game e.g. Main menu, Credits, and individual game panels.
*/
abstract class Screen {
    private ScreenManager scrnMgr;
    public String uid;


    public Screen (ScreenManager scrnMgr, String uid) {
        this.scrnMgr = scrnMgr;
        this.uid = uid;
    }

    public abstract void display();

    public abstract void onClick();

    public abstract void onType();

    public abstract void init();

    public void setManager(ScreenManager scrnMgr) {
        this.scrnMgr = scrnMgr;
    }

    public ScreenManager getScreenManager(){
        return this.scrnMgr;
    }

    public String toString() {
        return uid;
    }
}


class ScreenManager {
    public HashMap<String, Screen> screens = new HashMap<String, Screen>();
    public String currentScreenUid;
    private Screen previousScreen;

    final int transitionTime = 2000 * 2;//total time for transition/fade to black thing in milliseconds
    int currentTransitionProcess = -1; //How far it's into the transition. -1 shows that it's not currently in a transition.
    int transitionFrames = -1;

    private boolean isMute = false;

    public ScreenManager(){}

    /**
    * Onclick function that parses everything
    * Each scene handles its own onclick thing so that it's abstracted away
    * The ScreenManager blocks any clicks while the transition screen is happening.
    */
    public void onClick() {
        
        //will block any clicks that happen during transitions/loading time.
        if(currentTransitionProcess == -1) { 
            screens.get(currentScreenUid).onClick();
        }
    }

    public void onType() {
        if(currentTransitionProcess == -1) {
            screens.get(currentScreenUid).onType();
        }
    }

    public void display(){
        // if(currentTransitionProcess == 0) { 
        //     screens.get(currentScreenUid).init();
        // }

        screens.get(currentScreenUid).display();

        if(currentTransitionProcess >= 0) {
            if(currentTransitionProcess > transitionFrames / 2){
                previousScreen.display();
            }

            int percentAlpha = abs(round( 300 * (-(1.0f/frameRate / 2) * abs(currentTransitionProcess - frameRate / 2) + 1 )) );
            if(percentAlpha > 255) percentAlpha = 255;// add on extra time when black is at max opacity


            println("percentAlpha + currentTransitionProcess : "+percentAlpha + " " + currentTransitionProcess);
            fill(0, 0 , 0, percentAlpha);
            rect(0, 0, width, height);
            --currentTransitionProcess;
        }
        
    }

    public void add(Screen toAdd){
        println("Added: "+toAdd.uid);
        screens.put(toAdd.uid, toAdd);
    }

    /**
    * Removes a Screen from the screens map, making it impossible to use in the future.
    * Most likely won't ever be used since a HashMap has a lookup time of O(1)
    */
    public void remove(String screenUid){
        screens.remove(screenUid);
    }


    /**
    * Sets the screen e.g. from main menu to actual game.
    * Also deals with starting the thing to fade the whole screen to black and back.
    */
    public void setScreen(String screenUid) {
        previousScreen = screens.get(currentScreenUid);
        
        this.currentScreenUid = screenUid;
        screens.get(currentScreenUid).init();
        currentTransitionProcess = round(transitionTime * (1.0f / frameRate));
        transitionFrames = currentTransitionProcess;
        
    }

    public void init(Screen scr) {
        this.add(scr);
        this.currentScreenUid = scr.uid;
        this.previousScreen = scr;//prevent nullpointerexception
    }

    public void toggleSound() {
        this.isMute = !isMute;
    }

    public boolean getIsMute(){
        return isMute;
    }

    public String toString() {
        boolean isInTransition = false;
        if(currentTransitionProcess > -1 ){
            isInTransition = true;
        }
        return "ScreenManager: " + Arrays.deepToString(screens.values().toArray()) + "Transition?: " + isInTransition;
    }

}


  public void settings() {  size(960, 540); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "ProcessingIsBad" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
