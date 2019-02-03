import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import Screen; 
import java.util.HashMap; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class ProcessingCrap extends PApplet {

PShape s;

public void setup() {
    
    s = loadShape("./other.obj");
    frameRate(10);
}

int mod = 0;

public void draw() {
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
public abstract class Screen {

    public abstract void display(){

    }

    public Screen () {
        
    }

}




public class ScreenManager  {

    private Map<String, Screen> screens = new HashMap();

    private void changeScreen(String uid) {
        
    }

    public ScreenManager () {
        
    }

}
  public void settings() {  size(640,480, P3D); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "ProcessingCrap" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
