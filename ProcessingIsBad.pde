ScreenManager sm;
void setup() {
  sm = new ScreenManager();
  sm.add()
}


void draw() {
    sm.display();

}






/**
*
*
*
*/
abstract class Screen {

    public final abstract String uid;
    public abstract void display();

    public Screen () {

    }

}


class ScreenManager {
    Map<String, Screen> screens = new Map<>();
    public String currentScreenUid;

    final int transitionTime = 2000;//total time for transition/fade to black thing in milliseconds
    int currentTransitionProcess = -1;
    long lastTimeCheck;
    public ScreenManager(){}

    public void display(){
        screens.get(currentScreenUid).display();
    }

    public void add(Screen toAdd){
        screens.put(toAdd.uid, toAdd);b 
    }

    /**
    * Removes a Screen from the screens map, making it impossible to use in the future.
    * Most likely won't ever be used since a HashMap has a lookup time of O(1)
    */
    public void remove(String screenUid){
        screens.remove(toRemove);
    }


    /**
    * Changes the screen e.g. from main menu to actual game.
    * Also deals with starting the thing to fade the whole screen to black and back.
    */
    public void changeScreen(String screenUid){
        this.currentScreenUid = screenUid;
        this.currentTransitionProcess = 0;
        lastTimeCheck = millis();
    }



}


class TestMenu extends Screen{

    public final String uid = "TestScreen";
    public void display(){
        background(128);
        text("This is test screen" + String.toString(millis()), 40, 40, 15, 20);
    }

    public TestMenu () {
        
    }

}
