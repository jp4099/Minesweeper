import de.bezier.guido.*;
public final static int NUM_ROWS = 20;
public final static int NUM_COLS = 20;
public final static int NUM_BOMBS = 60;
private int nBombs = NUM_BOMBS;
private boolean lose = false;
//Declare and initialize NUM_ROWS and NUM_COLS = 20
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> bombs = new ArrayList <MSButton>(); //ArrayList of just the minesweeper buttons that are mined

void setup ()
{
    size(400, 400);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    for(int row = 0; row<buttons.length; row++){
        for(int col = 0; col<buttons[row].length;col++){
            buttons[row][col] = new MSButton(row,col);
        }
    //your code to declare and initialize buttons goes here
    
    }
    
    setBombs();
}

public void setBombs()
{
    while(bombs.size()<NUM_BOMBS) {
    int row = (int)(Math.random()*20);
    int col = (int)(Math.random()*20);
    
    if(!bombs.contains(buttons[row][col]))
        bombs.add(buttons[row][col]);
    }
}

public void draw ()
{
    background(255);

    if(isWon())
        displayWinningMessage();
    else {
        displayLosingMessage();
    }
}
public boolean isWon()
{
    int numMarked = 0;
    for(MSButton[] array: buttons){
        for(MSButton bu : array){
        if(bu.isMarked() && bombs.contains(bu))
            numMarked++;
        }
    }
    if(numMarked == NUM_BOMBS)
        return true;

    return false;
}
public void displayLosingMessage()
{
    stroke(255, 0, 0);
    strokeWeight(10);
    text("Sorry You lose!", 150, 200);
}
public void displayWinningMessage()
{
    stroke(0, 255, 0);
    strokeWeight(10);
    text("You're such a Winner!", 150, 200);
}

public class MSButton
{
    private int r, c;
    private float x,y, width, height;
    private boolean clicked, marked;
    private String label;
    
    public MSButton ( int rr, int cc )
    {
        width = 400/NUM_COLS;
        height = 400/NUM_ROWS;
        r = rr;
        c = cc; 
        x = c*width;
        y = r*height;
        label = "";
        marked = clicked = false;
        Interactive.add( this ); // register it with the manager
    }
    public boolean isMarked()
    {
        return marked;
    }
    public boolean isClicked()
    {
        return clicked;
    }
    // called by manager
    
    public void mousePressed () 
    {

        if(mouseButton == LEFT && !isClicked())
        clicked = true;
        
        if(mouseButton == RIGHT)
            marked = !marked;
        else if(bombs.contains(this) && clicked) 
            lose = true;    
        else if (countBombs(r, c) > 0)
            setLabel("" + countBombs(r, c));
        else{
            for(int row = -1;r<2;row++) {
                for(int col = -1; col<2;col++) {
                    if(isValid(row+r, col+c) && !buttons[row+r][col+c].isClicked()) {
                        buttons[row+r][col+c].mousePressed();
                    }
                }
            }
        }

    }

    public void draw () 
    {    
        if (marked)
            fill(0);
        else if( clicked && bombs.contains(this) ) 
            fill(28,0,0);
        else if(clicked)
            fill( 200 );
        else 
            fill( 100 );

        rect(x, y, width, height);
        fill(0);
        text(label,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel)
    {
        label = newLabel;
    }
    public boolean isValid(int r, int c)
    {
            if(r<NUM_ROWS && r >= 0 && c<NUM_COLS && c >= 0)
               return true;

                return false;
    }
    public int countBombs(int row, int col)
    {
        int numBombs = 0;
        for(int r = -1; r<2;r++){
            for(int c = -1;c <2; c++){
                if(isValid(row+r, col+c) && bombs.contains(buttons[row+r][col+c]))
                    numBombs++;
            }
        }
        return numBombs;
    }
}

