import gab.opencv.*;

import java.util.*;
import processing.video.*;

import static javax.swing.JOptionPane.*;

import java.util.regex.*;
ScreenManager sm;

final int opencvRefreshes = 4; //number of times opencv tries to detect faces per second
                                // intentionally can skip some frames to increase the performance of the game

void setup() {

    frameRate(60);
    size(640, 480);

    try{
        

        //Webcam stuff
        printArray(Capture.list());
        // int cameraIndex = Integer.parseInt(showInputDialog("Select the index"));
        int cameraIndex = 17; //DEBUG

        println("Initializing Webcam...");
        // video = new Capture(gameObject, 640, 480);
        //only support the webcam I have, sets the framerate as well
        String webcamConfig = Capture.list()[cameraIndex];
        
        println("Initizlitgin opencv");
        Pattern sizePattern = Pattern.compile("size=([0-9]+)x([0-9]+)");
        Matcher matcher = sizePattern.matcher(webcamConfig);
        if(matcher.find()){
            int camWidth = Integer.parseInt(matcher.group(1));
            int camHeight = Integer.parseInt(matcher.group(2));
            
            print(width + ", " + height);
            Capture video = new Capture(this, camWidth, camHeight);
            OpenCV opencv = new OpenCV(this, camWidth, camHeight);
            //screen manager stuff
            sm = new ScreenManager();
            sm.init(new MainMenu(sm));
            sm.add(new Game(sm, this, video, opencv));
            stroke(0);
        }
    
    
    } catch(Exception e) {
        println("Something dun goofed. Quitting.");
        System.exit(0);
    }
    

}

void webcamSelect() {
    println("Hello world");
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


//helper method to turn time into a number of frames
int timeToFrames(int time) {
    return round(frameRate / 1000.0 * time);
}

// webcam stuff
void captureEvent(Capture c) {
    c.read();
}