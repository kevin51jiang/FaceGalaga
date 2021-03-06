import gab.opencv.*;
import processing.video.*;


class ScreenManager {
    public HashMap<String, Screen> screens = new HashMap<String, Screen>();
    public String currentScreenUid;
    private Screen previousScreen;

    boolean isInTransition = false;

    private boolean isMute = false;


    public ScreenManager() {    }   

    /**
    * Onclick function that parses everything
    * Each scene handles its own onclick thing so that it's abstracted away
    * The ScreenManager blocks any clicks while the transition screen is happening.
    */
    public void onClick() {
        
        //will block any clicks that happen during transitions/loading time.
        if(!isInTransition) { 
            screens.get(currentScreenUid).onClick();
        }
    }

    public void onType() {
        if(!isInTransition) {
            screens.get(currentScreenUid).onType();
        }
    }

    public void display(){
        // if(currentTransitionProcess == 0) { 
        //     screens.get(currentScreenUid).init();
        // }

        screens.get(currentScreenUid).display();

        // if(currentTransitionProcess >= 0) {
        //     if(currentTransitionProcess > transitionFrames / 2){
        //         previousScreen.display();
        //     }

        //     int percentAlpha = abs(round( 300 * (-(1.0/frameRate / 2) * abs(currentTransitionProcess - frameRate / 2) + 1 )) );
        //     if(percentAlpha > 255) percentAlpha = 255;// add on extra time when black is at max opacity


        //     println("percentAlpha + currentTransitionProcess : "+percentAlpha + " " + currentTransitionProcess);
        //     fill(0, 0 , 0, percentAlpha);
        //     rect(0, 0, width, height);
        //     --currentTransitionProcess;
        // }
        
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

        pushMatrix();
        fill(0);
        rect(0, 0, width, height); //set screen to black
        popMatrix();
         
        isInTransition = true;
        screens.get(currentScreenUid).init();// load new screen
        isInTransition = false;
        
        
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
  
        return "ScreenManager: " + Arrays.deepToString(screens.values().toArray()) + "Transition?: " + isInTransition;
    }

}


