
class Button {

    public PVector corner1, corner2;

    public Button (PVector origin, PVector dimensions) throws Exception{
        this.corner1 = origin;
        this.corner2 = new PVector(origin.x + dimensions.x, origin.y + dimensions.y);

        
        if(dimensions.x < 1 || dimensions.y < 1) {
            throw new Exception("Width and height of a button must be positive");
        }
    }

    public Button (PVector origin, int wide, int high) throws Exception {
        this.corner1 = origin;
        this.corner2 = new PVector(origin.x + wide, origin.y + high);

        
        if(wide <1 || high < 1) {
            throw new Exception("Width and height of a button must be positive");
        }
    }

    public Button (int x, int y, int wide, int high) throws Exception {
        this.corner1 = new PVector(x, y);
        this.corner2 = new PVector(x + wide,  y + high);

        if(wide <1 || high < 1) {
            throw new Exception("Width and height of a button must be positive");
        }
    }

    public String toString(){
        return "C1: " + corner1.x + ", " + corner1.y + "\n"
                +"C2: " + corner2.y + ", " + corner2.y + "\n";
    }

    public boolean isClicked(){

        if(mouseX > corner1.x && mouseX < corner2.x
            && mouseY >corner1.y &&  mouseY < corner2.y ){
                return true;
        } else {
            return false;
        }
    }

}
