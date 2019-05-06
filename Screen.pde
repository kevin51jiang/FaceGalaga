/**
* Generic Screen object. Handles all the internal logic / displaying by itself.
* Used for big chunks of the game e.g. Main menu, Credits, and individual game panels.
*/
abstract class Screen {
    private ScreenManager scrnMgr;
    public String uid;


    public Screen (ScreenManager scrnMgr, String uid) {
        this.scrnMgr = scrnMgr;
        this.uid = uid;
    }

    public abstract void display();

    public abstract void onClick();

    public abstract void onType();

    public abstract void init();

    public void setManager(ScreenManager scrnMgr) {
        this.scrnMgr = scrnMgr;
    }

    public ScreenManager getScreenManager(){
        return this.scrnMgr;
    }

    public String toString() {
        return uid;
    }
}

