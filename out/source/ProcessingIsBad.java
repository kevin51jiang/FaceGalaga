import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.*; 

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
public void setup() {
    
      
  sm.add(new TestMenu());
}


public void draw() {
    sm.display();

}






/**
*
*
*
*/
abstract class Screen {

    public String uid;
    public abstract void display();

    public Screen () {

    }

}


static class ScreenManager {
    public HashMap<String, Screen> screens = new HashMap<String, Screen>();
    public String currentScreenUid;

    final int transitionTime = 2000;//total time for transition/fade to black thing in milliseconds
    int currentTransitionProcess = -1;
    long lastTimeCheck;
    public ScreenManager(){}

    public void display(){
        screens.get(currentScreenUid).display();
    }

    public void add(Screen toAdd){
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

    public String uid = "TestScreen";
    public void display(){
        background(128);
        text(("This is test screen" + millis()), 40, 40, 100, 100);

        rect(200, 200, 350, 200);
    }

    public TestMenu () {
        
    }

}
  public void settings() {  size(640, 480); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "ProcessingIsBad" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
