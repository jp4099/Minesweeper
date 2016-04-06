import de.bezier.guido.*;
public final static int NUM_ROWS = 20;
public final static int NUM_COLS = 20;
public boolean gameOver = false;
public boolean win = false;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> bombs = new ArrayList <MSButton>(); //ArrayList of just the minesweeper buttons that are mined

void setup ()
{
    size(400, 400);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    for(int nrow = 0; nrow<NUM_ROWS; nrow++){
        for(int ncol = 0; ncol<NUM_COLS;ncol++){
            buttons[nrow][ncol] = new MSButton(nrow,ncol);
        }
    }
    setBombs();
}

public void setBombs()
{
    for(int i -1;i<40;i++) {
    int row = (int)(Math.random()*NUM_ROWS);
    int col = (int)(Math.random()*NUM_COLS);
    
    if(!bombs.contains(buttons[row][col]))
        bombs.add(buttons[row][col]);
    }
}

public void draw ()
{
    if(isWon())
        displayWinningMessage();
    
}
public boolean isWon()
{
    int timesClicked = 0;
    int countBomb=0;
    for(int r = 0;r<NUMS_ROWS;r++)
    {
      for(int c = 0; c< NUM_COLS;c++) {
            if(buttons[r][c].isClicked())
            timesClicked++;
            if(bombs.contains(buttons[r][c]))
            countBomb++;
            if(NUM_ROWS*NUM_COLS == timesClicked+countBomb)
            return true;
        }
    }
    return false;
}
public void displayLosingMessage()
{
    for(int i = 0; i < bombs.size();i++)
    {
        if(bombs.get(i).isMarked() == false)
        bombs.get(u).clicked = true;
    }
    stroke(255, 0, 0);
    strokeWeight(10);
    text("Sorry You lose!", 150, 200);
    gameOver = true;
}
public void displayWinningMessage()
{
    stroke(0, 255, 0);
    strokeWeight(10);
    text("You're such a Winner!", 150, 200);
    gameOver = true;
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

    public void mousePressed () 
    {
        if(gameOver == false) 
        {
            if(mouseButton == LEFT && marked == false){
            clicked = true;
            unClickedTiles--;
            }
            if(mouseButton == RIGHT && clicked == false)
            {
                marked = !marked;
                 if(!isMarked()) 
                    unmarkedBombs++;
                else if (isMarked())
                    unmarkedBombs--;
            }
            else if (bombs.contains(this) && marked == false) 
                displayLosingMessage();
            else if (countBombs(r, c)>0)
                setLabel(str(countBombs(r, c)));
            else
                for(int row = -1;r<=1;row++) {
                    for(int col = -1; col<=1;col++) {
                        if(isValid(row+r, col+c) && !buttons[row+r][col+c].isClicked()) 
                            buttons[row+r][col+c].mousePressed();
        }

    }

    public void draw () 
    {    
        if (marked)
            fill(0);
        else if( clicked && bombs.contains(this) ) 
            fill(255,0,0);
        else if(clicked)
            fill( 200 );
        else 
            fill( 100 );

        rect(x, y, width, height);
        fill(0);
        textSize(10);
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
        for(int r = -1; r<=1;r++){
            for(int c = -1;c <=1; c++){
                if(isValid(row+r, col+c) && bombs.contains(buttons[row+r][col+c]))
                    numBombs++;
            }
        }
        return numBombs;
    }
}

