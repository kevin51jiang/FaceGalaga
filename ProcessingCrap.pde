PShape s;

void setup() {
    size(640,480, P3D);
    s = loadShape("./other.obj");
    frameRate(10);
}

int mod = 0;

void draw() {
    background(0);
    textSize(32);
    translate(width/2, height/2);
    fill(0, 102, 153, 204);

    rect(20, 20, 150, 120);
    text("word", 12, 45, -30);  // Specify a z-axis value
    text("word", 12, 60);
    
  
    shape(s, 0, 0);
    camera(width/2, height/2, (height/2) / tan((PI + mod)/6), width/2, height/2, 0, 0, 1, 0);

    lights();

    ++mod;

}






/**
*
*
*
*/
abstract class Screen {

    public abstract String uid;
    public abstract void display();

    public Screen (arguments) {

    }

}


class ScreenManager {
    Map<String, Screen> screens = new Map<>();
    public String currentScreenUid;

    final int transitionTime = 2000;//total time for transition/fade to black thing in milliseconds
    int currentTransitionProcess = -1;

    public ScreenManager(){}

    public void display(){
        screens.get(currentScreenUid).display();
    }

    public void addScreen(Screen toAdd){
        screens.put(toAdd.uid, toAdd)
    }

    /**
    * Removes a Screen from the screens map, making it impossible to use in the future.
    * Most likely won't ever be used since a HashMap has a lookup time of O(1)
    */
    public void removeScreen(String screenUid){
        screens.remove(toRemove);
    }

    public void changeScreen(String screenUid){
        this.currentScreenUid = screenUid;
    }



}
