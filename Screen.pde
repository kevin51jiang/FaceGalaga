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


