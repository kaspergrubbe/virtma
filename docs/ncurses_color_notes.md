# rabbitboots.com

Source: https://rabbitboots.com/blog/2016/11/02/pdcurses/

## Color Pairs

Though Curses does define macros to represent eight colors (0 through 7 — COLOR_BLACK, COLOR_WHITE etc), you can’t pass these to the Curses drawing functions directly. Instead, you initialize a series of color pairs, and pass the index of that pair as an attribute. If you want to address all 8 foreground and 8 background colors independently, you can initialize 64 pairs with each combination.

(Note: Color Pair 0 is already initialized, and reserved for monochrome mode.)

```c
int cursesIndexColorPairs(void) {
    int n_colors = 8;
    int color_index_start = 1;
    int i;

    for( i = 0; i < n_colors * n_colors; i++ ) {
        if( init_pair( color_index_start + i, i % n_colors, i / n_colors ) == ERR) {
            return ERR;
        }
    }
    return 0;
}
```

## Bright and Dark colors

The Windows command prompt supports legacy IBM PC Text Mode colors. There are 16 colors total, but they are accessed as 8 base colors, plus a brightness flag. The foreground and background of a given character get their own color and brightness parameters. In DOS, if the background color has a brightness flag, then the foreground color will blink on and off and the background intensity will be unchanged. A non-fullscreen Windows command prompt will just draw the background color as bright.

PDCurses will draw a character with a bright foreground if A_BOLD is passed as an attribute, and it will draw with a bright background if A_BLINK is passed, and both if they are passed sequentially or binary OR’d together. I can’t imagine A_BLINK serving as a bright background would be portable on other systems, but it’s the only attribute I could find that did so on Windows 10.

```c
#define N_COLORS 8

int colorGetPair(int fg, int bg) {
  // return monochrome (pair 0) if requested colors are out of range
  if(fg < 0 || fg > N_COLORS || bg < 0 || bg > N_COLORS ) {
    return 0;
  }
  else {
    return 1 + fg + (bg * N_COLORS);
  }
}

void colorSet( int fg, int bg, int fg_intensity, int bg_blink ) {
  if( fg_intensity ) {
    attron( A_BOLD );
  }
  else {
    attroff( A_BOLD );
  }

  if( bg_blink ) {
    attron( A_BLINK );
  }
  else {
    attroff( A_BLINK );
  }

  attron( COLOR_PAIR( colPair( fg, bg ) ) );
}

int main() {

  // ... snip
  colorSet( COLOR_MAGENTA, COLOR_CYAN, 1, 1 );
  mvprintw( 0, 0, "\"We need more searing Magenta and Cyan,\"\n said the CGA Project Lead." );
  getch();

  // ... snip
```

# taskwarrior.wordpress.com

Source: https://taskwarrior.wordpress.com/2013/12/09/codebase-101-color/

## Custom xterm naming convention

### Naming Convention

This is simply a way to map the XTerm escape sequences into some more readable and usable set of names for colors.  There are four ways to specify colors, the first is by simple name:

`red, blue, black, green, cyan, magenta, yellow, white`

These are the simple 8-color names.  Then there is an RGB model:

`rgb000 – rgb555`

This ranges from `black (rgb000)` to `white (rgb555)` through a color cube, where the red, green and blue components each have six possible values `(0, 1, 2, 3, 4, 5)`.  The model maps these coordinates to the right escape sequence, which, as one would hope, follows an orderly convention.

There there are the 24 grey colors:

`gray0 – gray23`

These follow a monochrome scale, and are used in the demo “task logo” command (go ahead, try it).

Finally there is a direct specification of all 256 colors using:

`color0 – color255`

This sequences ranges from the 8 standard colors, the brighter equivalents, through the color cube, to the gray-scale.

### Composition

The color model provides a small language to allow composition.  For example, there is the trivial case of just specifying a foreground color:

`red`

But to distinguish foreground from background, the syntax used the word "on":

`red on blue`

This can include other attributes, such as:

`bold red underline on bright blue`

Any of the naming conventions can be used here.
