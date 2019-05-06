/**
*   Animation Manager in the form of a queue
*/
class AnimationQueue {
    private ArrayList<Animatable> currentAnimations = new ArrayList<Animatable>();
    public AnimationQueue() {}

    /**
    * @param  anim  Animatable object to add.
    * Adds an animatable object to the queue for display in the future.
    * It should already have its animation parameters already preset.
    */
    public void add(Animatable anim){
        currentAnimations.add(anim);
    }

    /**
    * @param  anim  The Animatable object to remove
    * Manually removes an object from the animation queue (stop it from being displayed in the next cycle)
    */
    public void remove(Animatable anim){
        currentAnimations.remove(anim);
    }

    /**
    *   Displays everything in the queue by iterating over everything.
    */
    public void display() {
        //run the animation queue in reverse to prevent random flashing
        for(int i = currentAnimations.size() - 1; i >= 0; i--){

            //push and pop matrix to keep each element self contained
            pushMatrix();
            currentAnimations.get(i).display(); // display the element
            popMatrix();
        }

    
    }

    public ArrayList<Animatable> dumpQueue() {
        return currentAnimations;
    }

}

