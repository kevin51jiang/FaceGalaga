import java.util.*;
import processing.video.*;
import gab.opencv.*;

ScreenManager sm;

final int opencvRefreshes = 4; //number of times opencv tries to detect faces per second
                                // intentionally can skip some frames to increase the performance of the game

void setup() {

    frameRate(60);
    size(960, 540);
    sm = new ScreenManager();
    sm.init(new MainMenu(sm));
    stroke(0);
}

void draw() {
    sm.display();

    // if(frameCount%240 == 0) {
    //     println("Screens included: "+Arrays.deepToString(sm.screens.values().toArray()));
    // }

} 

void mousePressed(){
    sm.onClick();
}

void keyPressed() {
    sm.onType();
}


int timeToFrames(int time) {
    return round(frameRate / 1000.0 * time);
}