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

    public ScreenManager(){}

    public void addScreen(Screen toAdd){
        screens.put(toAdd.uid, toAdd)
    }

    public void removeScreen(String screenUid){
        screens.remove(toRemove);
    }

}
