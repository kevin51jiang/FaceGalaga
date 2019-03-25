
/**
* Class that implements linear animations ----- may switch towards eased in/out animations in the future
*/
abstract class Animatable {
    PVector start, current, dest;
    AnimationQueue queue;
    private float framesLeft, framesMax;
    
    /**
    *   Time is in milliseconds
    */
    public Animatable(PVector start, PVector dest, int time, AnimationQueue queue){
        this.current = start;
        this.addAnimation(dest, time, queue);
    }

    /**
    *   Made specifically for objects that start at the top and
    *   go completely vertical down until they despawn.
    */
    public Animatable(int x, int y, int deltaY, int time, AnimationQueue queue) {
        this.current = new PVector(x, y);
        PVector dest = new PVector(x, y + deltaY);
        this.addAnimation(dest, time, queue);
    }

    public Animatable(PVector start) {
        this.start = start;
        this.current = start;
        this.dest = start;
        framesLeft = 0;
        framesMax = 0;
    }


    /*
    *   Subclasses will ALWAYS call super.display() at the end of their display() methods to help with cleanup.
    */
    public void display() {
        this.framesLeft--;

        //if it has no frames left, remove it from the queue and it will stop being displayed
        if(framesLeft <= 0){//do less than instead of == because floats are weird
            queue.remove(this);
        }
    }

    public void addAnimation(PVector dest, int time, AnimationQueue queue){
        this.start = current;
        this.dest = dest;

        this.framesMax = timeToFrames(time);
        this.framesLeft = framesMax;

        this.queue = queue;

        // println("added anim: " + start.x + ", " + start.y + " - " + dest.x + ", " + dest.y);
    }

    public void addDeltaAnimation(PVector delta, int time, AnimationQueue queue){
        this.start = current;
        this.dest = new PVector(current.x + delta.x, current.y + delta.y);

        this.framesMax = timeToFrames(time);
        this.framesLeft = framesMax;

        this.queue = queue;

        println("added anim: " + start.x + ", " + start.y + " - " + dest.x + ", " + dest.y);

    }

    /*
    *   If ever implement a bezier ease in/out system, this is the method that needs changing.
    */
    public PVector getCurrentPos() {


        current = PVector.lerp(dest, start, framesLeft / framesMax);
        //println("Current pos: " + current.x + ", " + current.y + " lerp%= " + framesLeft/framesMax * 100);
        return current;
    }
        
    public boolean isInAnimation() {
        return framesLeft > 0;
    }

    

}




