import de.bezier.guido.*;
private MSButton[][] buttons; 
private ArrayList <MSButton> bombs = new ArrayList<MSButton>(); 
public final static int  NUM_ROWS = 20;
public final static int NUM_COLS = 20;
public final static int BOMBS = 50;
boolean gameOver = false;

void setup ()
{
  size(400, 500);
  textAlign(CENTER, CENTER);
  bombs = new ArrayList();
  Interactive.make( this );
  buttons = new MSButton[20][20];
  for (int r = 0; r < NUM_ROWS; r++ )
  {
    for (int c = 0; c < NUM_COLS; c++ )
    {
      buttons[r][c] = new MSButton(r, c);
    }
  }
  setBombs();
}
public void setBombs()
{
  while (bombs.size() < BOMBS)
  {
    int r = (int)(Math.random()*(NUM_ROWS));
    int c = (int)(Math.random()*(NUM_COLS));
    if (!(bombs.contains(buttons[r][c])))
    {
      bombs.add(buttons[r][c]);
    }
  }
}

public void draw ()
{
  if (gameOver == true)
  {
    fill(255);
    textSize(15);
    text ("o no phat L ):", 200, 450);
  } else
  {
    background( 0 );

    if (isWon())
      displayWinningMessage();
  }
}

public boolean isWon()
{
  for (int r = 0; r < NUM_ROWS; r++ )
  {
    for (int c = 0; c < NUM_COLS; c++ )
    {
      if ( buttons[r][c].isClicked()== false)
      {
        return false;
      }
    }
  }
  return true;
}

public void displayLosingMessage()
{
  fill(255);
  for (int r = 0; r < NUM_ROWS; r++ )
  {
    for (int c = 0; c < NUM_COLS; c++ )
    {
      buttons[r][c].clicked = true;
    }
  }  
  gameOver = true;
}

public void displayWinningMessage()
{
  fill(255);
  textSize(20);
  text ("AYY CONGRATS (:", 200, 450);
}

public class MSButton
{
  private int r, c;
  private float x, y, width, height;
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
    Interactive.add( this );
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
    if (gameOver == true)
      return;
    clicked = true;
    if (mouseButton == RIGHT)
    {
      marked =! marked;
      if (marked == false)
        clicked = false;
    } else if (bombs.contains(this))
      displayLosingMessage();
    else if (countBombs(r, c) > 0)
      label = "" + countBombs(r, c);
    else
    {
      if (isValid(r, c+1) && buttons[r][c+1].clicked == false)
        buttons[r][c+1].mousePressed();

      if (isValid(r, c-1) && buttons[r][c-1].clicked == false)
        buttons[r][c-1].mousePressed();

      if (isValid(r+1, c) && buttons[r+1][c].clicked == false)
        buttons[r+1][c].mousePressed();

      if (isValid(r-1, c) && buttons[r-1][c].clicked == false)
        buttons[r-1][c].mousePressed();

      if (isValid(r+1, c+1) && buttons[r+1][c+1].clicked == false)
        buttons[r+1][c+1].mousePressed();

      if (isValid(r+1, c-1) && buttons[r+1][c-1].clicked == false)
        buttons[r+1][c-1].mousePressed();

      if (isValid(r-1, c+1) && buttons[r-1][c+1].clicked == false)
        buttons[r-1][c+1].mousePressed();

      if (isValid(r-1, c-1) && buttons[r-1][c-1].clicked == false)
        buttons[r-1][c-1].mousePressed();
    }
  }

  public void draw () 
  {    
    if (marked)
      fill(0);
    else if ( clicked && bombs.contains(this) ) 
      fill(255, 0, 0);
    else if (clicked)
      fill( 200 );
    else 
    fill( 100 );

    rect(x, y, width, height);
    fill(0);
    text(label, x+width/2, y+height/2);
  }
  public void setLabel(String newLabel)
  {
    label = newLabel;
  }
  public boolean isValid(int r, int c)
  {
    if (r >= 0 && c >= 0 && r < NUM_ROWS && c < NUM_COLS)
      return true;
    else
      return false;
  }

  public int countBombs(int row, int col)
  {
    int numBombs = 0;
    if (isValid(r, c-1)&& bombs.contains(buttons[r][c-1]))
      numBombs++;

    if (isValid(r, c+1)&& bombs.contains(buttons[r][c+1]))
      numBombs++;

    if (isValid(r-1, c)&& bombs.contains(buttons[r-1][c]))
      numBombs++;

    if (isValid(r+1, c)&& bombs.contains(buttons[r+1][c]))
      numBombs++;

    if (isValid(r+1, c+1)&& bombs.contains(buttons[r+1][c+1]))
      numBombs++;

    if (isValid(r+1, c-1)&& bombs.contains(buttons[r+1][c-1]))
      numBombs++;

    if (isValid(r-1, c-1)&& bombs.contains(buttons[r-1][c-1]))
      numBombs++;

    if (isValid(r-1, c+1)&& bombs.contains(buttons[r-1][c+1]))
      numBombs++;
    return numBombs;
  }
}
