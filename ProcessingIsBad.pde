import java.util.*;

ScreenManager sm;
void setup() {

    frameRate(60);
    size(640, 480);
    sm = new ScreenManager();
    sm.init(new TestMenu(sm, "Scr1"));
    sm.add(new TestMenu2(sm, "Scr2"));

    nostroke();
}

void draw() {
    sm.display();

    if(frameCount%240 == 0){
        println("Screens included: "+Arrays.deepToString(sm.screens.values().toArray()));
    }

} 

void mousePressed(){
    if(sm.currentScreenUid.equals("Scr1")) {
        sm.setScreen("Scr2");
    } else {
        sm.setScreen("Scr1");
    }
}






/**
* Generic Screen object. Handles all the internal logic / displaying by itself.
* Used for big chunks of the game e.g. Main menu, Credits, and individual game panels.
*/
abstract class Screen {
    private ScreenManager scrnMgr;
    public String uid;

    public abstract void display();

    public abstract void onClick();

    public Screen (ScreenManager scrnMgr, String uid) {
        this.scrnMgr = scrnMgr;
        this.uid = uid;
    }

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
        if(currentTransitionProcess < -1) {
            screens.get(currentScreenUid).onClick();
        }
    }

    public void display(){
        screens.get(currentScreenUid).display();

        if(currentTransitionProcess >= 0) {
            if(currentTransitionProcess > transitionFrames / 2){
                previousScreen.display();
            }

            int percentAlpha = round(1.5 * 255 * (-(1.0/frameRate) * abs(currentTransitionProcess - frameRate) + 1 ));
            if(percentAlpha > 255)  percentAlpha = 255;

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
    public void setScreen(String screenUid){
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


class TestMenu extends Screen{

        public TestMenu(ScreenManager sm, String uid) {
        super(sm, uid);
    }


    public void display(){
        background(255, 0, 0);
        text(("This is test screen" + millis()), 40, 40, 100, 100);

        rect(200, 200, 350, 200);
    }


    public void onClick(){

    }

}

class TestMenu2 extends Screen {
    

    public void display() {
        background(0, 255, 0);
        text("This is the second test screen" + millis(), 40, 40, 100, 100);
    }

    public TestMenu2(ScreenManager sm, String uid){
        super(sm, uid);
    };

    public void onClick() {

    }

}
