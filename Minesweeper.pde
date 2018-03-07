import de.bezier.guido.*;
int NUM_ROWS = 30;
int NUM_COLS = 30; 
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> bombs; //ArrayList of just the minesweeper buttons that are mined
private boolean gameOver;
private int nBombs = 40;
private PFont Font1; 
private PFont Font2;

void setup ()
{
    size(600, 650);
    textAlign(CENTER,CENTER);
    Font1 = createFont("Arial Bold", 15);
    Font2 = createFont("Arial", 20);
    bombs = new ArrayList <MSButton> (); 
    // make the manager
    Interactive.make( this );
    
    //your code to declare and initialize buttons goes here
    buttons = new MSButton [NUM_ROWS] [NUM_COLS];
    for (int row = 0; row < NUM_ROWS; row++)
    {
        for (int col = 0; col < NUM_COLS; col++)
        {
            buttons[row][col] = new MSButton(row, col);
        }
    }
    
    setBombs();
    gameOver = false; 
}

public void setBombs()
{ 
    for (int i = 0; i < nBombs; i++ )
    {
        int r = (int)(Math.random()*NUM_ROWS);
        int c = (int)(Math.random()*NUM_COLS); 

        if (!bombs.contains(buttons[r][c]))
        {
            bombs.add(buttons[r][c]);
        }
    }
}

public void draw ()
{
    background(0);
    if(!gameOver && isWon())
    {
        displayWinningMessage();
    }
}

public boolean isWon()
{
    for (int r = 0; r < NUM_ROWS; r++)
        for (int c = 0; c < NUM_COLS; c++)
        {
            if (!bombs.contains(buttons[r][c]) && !buttons[r][c].isClicked())
                return false;
        }
    return true;
}
public void displayLosingMessage()
{

    buttons[15][12].setLabel("L");
    buttons[15][13].setLabel("O");
    buttons[15][14].setLabel("S");
    buttons[15][15].setLabel("3");
    buttons[15][16].setLabel("R");
    buttons[15][17].setLabel("!");
    
    //textSize(20);
    textFont(Font2);
    fill(255);
    text("Aww..you lost :(", 300, 620);

}

public void displayWinningMessage()
{
    buttons[15][12].setLabel("W");
    buttons[15][13].setLabel("I");
    buttons[15][14].setLabel("N");
    buttons[15][15].setLabel("N");
    buttons[15][16].setLabel("3");
    buttons[15][17].setLabel("R");

    textFont(Font2);
    fill(255);
    text("OMG! WINNER!!!!!", 300, 625);
}

public class MSButton
{
    private int r, c;
    private float x,y, width, height;
    private boolean clicked, marked;
    private String label;
    private PFont font3; 

    public MSButton ( int rr, int cc )
    {
        width = 600/NUM_COLS;
        height = 600/NUM_ROWS;
        r = rr;
        c = cc; 
        x = c*width;
        y = r*height;
        label = "";
        marked = clicked = false;
        font3 = createFont("Arial Bold", 15);
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
        clicked = true;

        if (keyPressed == true)
        {
            marked = !marked;
        }

        else if (bombs.contains(this) && gameOver == false)
        {
            for (int r = 0; r < NUM_ROWS; r++)
            {
                for (int c = 0; c < NUM_COLS; c++)
                {
                    if(bombs.contains(buttons[r][c]) && !buttons[r][c].isClicked())
                        buttons[r][c].mousePressed();
                }
            }

            gameOver = true;
            displayLosingMessage();
            // noLoop();

        }
        else if (countBombs(r, c) > 0)
        {
            setLabel("" + countBombs(r, c));
        }
        else
        {
            if (isValid(r, c-1) && buttons[r][c-1].isClicked() == false)
                (buttons[r][c-1]).mousePressed();
            if (isValid(r, c+1) && buttons[r][c+1].isClicked() == false)
                 buttons[r][c+1].mousePressed();
            if (isValid(r-1, c) && buttons[r-1][c].isClicked() == false)
                 buttons[r-1][c].mousePressed();
            if (isValid(r+1,c) && buttons[r+1][c].isClicked() == false)
                 buttons[r+1][c].mousePressed();
            if (isValid(r-1,c-1) && buttons[r-1][c-1].isClicked() == false)
                 buttons[r-1][c-1].mousePressed();
            if (isValid(r+1,c+1) && buttons[r+1][c+1].isClicked() == false)
                 buttons[r+1][c+1].mousePressed();
            if (isValid(r+1,c-1) && buttons[r+1][c-1].isClicked() == false)
                buttons[r+1][c-1].mousePressed();
            if (isValid(r-1, c+1) && buttons[r-1][c+1].isClicked() == false)
                buttons[r-1][c+1].mousePressed();
        }
    }

    public void draw () 
    {    
        if (marked)
            fill(0);
        else if( clicked && bombs.contains(this) ) 
            fill(255, 0, 0);
        else if(clicked)
            fill(200);
        else 
            fill(100);

        rect(x, y, width, height);
        fill(0);

        if (countBombs(r,c) == 1) { fill(42, 70, 161);}
        if (countBombs(r,c) == 2) { fill(37, 153, 22);}
        if (countBombs(r,c) == 3) { fill(194, 36, 8);}

        textFont(font3);
        text(label,x+width/2,y+height/2);
    }

    public void setLabel(String newLabel)
    {
        label = newLabel;
    }

    public boolean isValid(int r, int c)
    {
        if (r < NUM_ROWS && r >= 0 && c < NUM_COLS && c >= 0)
        {
            return true;
        }
        else 
        {
            return false;
        }
    }


    public int countBombs(int row, int col)
    {
        int numBombs = 0;
        if (isValid(r+1, c)&&bombs.contains(buttons[r+1][c]))
        {
            numBombs++;
        }
        if (isValid(r, c+1)&&bombs.contains(buttons[r][c+1]))
        {
            numBombs++;
        }
        if (isValid(r-1, c)&&bombs.contains(buttons[r-1][c]))
        {
            numBombs++;
        }
        if (isValid(r, c-1)&&bombs.contains(buttons[r][c-1]))
        {
            numBombs++;
        }
        if (isValid(r+1, c+1)&&bombs.contains(buttons[r+1][c+1]))
        {
            numBombs++;
        }
        if (isValid(r-1, c-1)&&bombs.contains(buttons[r-1][c-1]))
        {
            numBombs++;
        }
        if (isValid(r+1, c-1)&&bombs.contains(buttons[r+1][c-1]))
        {
            numBombs++;
        }
        if (isValid(r-1, c+1)&&bombs.contains(buttons[r-1][c+1]))
        {
            numBombs++;
        }
        return numBombs;
    }

}



