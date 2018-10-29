
# Habit tracking calendar

I use this script and Makefile to generate a calendar for the year with
all weekdays in the same column and one line per week.

To generate a calender you need make, lua, pdflatex and pstricks.

The Makefile makes it easier to generate a new calendar.
Just call

    $ make YEAR=2018

to generate a calendar for 2018.
You can find the generated calendar in *kalender2018.pdf*.

This call to make does nothing more than

    $ ./kalender.lua 2018 > kalender2018.tex
    $ latex kalender2018.tex
    $ dvips kalender2018.dvi
    $ ps2pdf kalender2018.ps

Enjoy your new calendar.

## Installation

On Ubuntu 18.04 the following command will install the necessary programs:

    $ sudo apt install lua5.2 make texlive-pstricks

