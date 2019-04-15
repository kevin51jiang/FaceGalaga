import gab.opencv.*;

import java.util.*;
import processing.video.*;

ScreenManager sm;

final int opencvRefreshes = 4; //number of times opencv tries to detect faces per second
                                // intentionally can skip some frames to increase the performance of the game

void setup() {

    frameRate(60);
    size(960, 540);
    ortho();
    sm = new ScreenManager();
    sm.init(new MainMenu(sm));
    sm.add(new Game(sm, this));
    stroke(0);


}
void draw() {
   

    sm.display();
    
} 

void mousePressed(){
    sm.onClick();
    println("clicc");
}

void keyPressed() {
    sm.onType();
}

int currentZoom = -1;

void mouseWheel(MouseEvent event) {
    int wheel = event.getCount();
    
    
}



int timeToFrames(int time) {
    return round(frameRate / 1000.0 * time);
}
