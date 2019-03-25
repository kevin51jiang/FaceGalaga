/**
*   Animation Manager in the form of a queue
*/
class AnimationQueue {
    private ArrayList<Animatable> currentAnimations = new ArrayList<Animatable>();
    public AnimationQueue() {}

    public void add(Animatable anim){
        currentAnimations.add(anim);
    }

    public void remove(Animatable anim){
        currentAnimations.remove(anim);
    }

    public void display() {
        for(int i = currentAnimations.size() - 1; i >= 0; i--){
            currentAnimations.get(i).display();
        }

    
    }

}

