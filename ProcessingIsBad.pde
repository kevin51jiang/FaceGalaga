import java.util.*;
import processing.video.*;
import gab.opencv.*;

ScreenManager sm;

void setup() {

    frameRate(60);
    size(1100, 600);
    sm = new ScreenManager();
    sm.init(new MainMenu(sm));

    stroke(0);
}

void draw() {
    sm.display();

    if(frameCount%240 == 0) {
        println("Screens included: "+Arrays.deepToString(sm.screens.values().toArray()));
    }

} 

void mousePressed(){
    sm.onClick();
}


int timeToFrames(int time) {
    return round(frameRate / 1000.0 * time);
}


// 
// END OF NORMAL PROCESSING SKETCH
// 
// START OF ANIMATION OBJECTS
// 

class AnimationQueue {
    private ArrayList<Animatable> currentAnimations = new ArrayList<Animatable>();
    public AnimationQueue() {}

    public void addNew(Animatable anim){
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
        this.start = start;
        this.dest = dest;

        this.framesMax = timeToFrames(time);
        this.framesLeft = framesMax;

        this.queue = queue;
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


    /*
    *   If ever implement a bezier ease in/out system, this is the method that needs changing.
    */
    public PVector getCurrentPos() {
        return PVector.lerp(start, dest, framesLeft / framesMax);
    }
        


}

// 
// END OF ANIMATION OBJECTS
// 
// START OF SCREEN OBJECTS
// 


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

    public void setManager(ScreenManager scrnMgr) {
        this.scrnMgr = scrnMgr;
    }

    public ScreenManager getScreenManager(){
        return this.scrnMgr;
    }
}


class ScreenManager {
    public HashMap<String, Screen> screens = new HashMap<String, Screen>();
    public String currentScreenUid;
    private Screen previousScreen;

    final int transitionTime = 2000 * 2;//total time for transition/fade to black thing in milliseconds
    int currentTransitionProcess = -1; //How far it's into the transition. -1 shows that it's not currently in a transition.
    int transitionFrames = -1;

    public ScreenManager(){}

    /**
    * Onclick function that parses everything
    * Each scene handles its own onclick thing so that it's abstracted away
    * The ScreenManager blocks any clicks while the transition screen is happening.
    */
    public void onClick() {
        //will block any clicks that happen during transitions/loading time.
        if(currentTransitionProcess > -1) {
            screens.get(currentScreenUid).onClick();
        }
    }

    public void display(){
        screens.get(currentScreenUid).display();

        if(currentTransitionProcess >= 0) {
            if(currentTransitionProcess > transitionFrames / 2){
                previousScreen.display();
            }

            int percentAlpha = round( 255 * (-(1.0/frameRate / 2) * abs(currentTransitionProcess - frameRate / 2) + 1 )) ;
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

        currentTransitionProcess = round(transitionTime * (1.0 / frameRate));
        transitionFrames = currentTransitionProcess;
        
    }

    public void init(Screen scr) {
        this.add(scr);
        this.currentScreenUid = scr.uid;
        this.previousScreen = scr;//prevent nullpointerexception
    }



}

// 
// END OF SCREEN OBJECTS
// 
// START OF SPECIFIC SCREENS/ANIMATION OBJECTS
// 

class TestMenu extends Screen {

        public TestMenu(ScreenManager sm, String uid) {
        super(sm, uid);
    }


    public void display() {
        background(255, 0, 0);
        text(("This is test screen" + millis()), 40, 40, 100, 100);

        rect(200, 200, 350, 200);
    }


    public void onClick() {

    }

}

class MainMenu extends Screen {
    private final static String uid = "MainMenu";
    private PShape spaceship;
    private final color darksky = color(0, 0, 20);
    private final color medSky = color(0, 75, 127);
    private final color lightsky = color(7, 150, 255);
    private final int medSkyY = 30;


    public MainMenu(ScreenManager sm) { 
        super(sm, MainMenu.uid);
        spaceship = loadShape("./spaceship.svg");
        spaceship.rotate(2 * PI * 7.0/8.0);
    }

    public void display() {

        //Background
        noFill();
        for (int i = 0; i <= height; i++) {
            float inter = map(i, 0, height, 0, 1);
            color c = lerpColor(darksky, lightsky, inter);
            stroke(c);
            line(0, i, width, i);
        }
        shape(spaceship, width/2 - ( sqrt(2 * sq(height/(2.5))) / 2) , height/2, height/2.5, height/2.5);


       
    }

    public void onClick() {

    }
}
