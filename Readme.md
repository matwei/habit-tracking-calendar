
# Habit tracking calendar

I use this script and Makefile to generate a calendar for the year with
all weekdays in the same column and one line per week.

To generate a calender you need lua and pdflatex.

The Makefile makes it easyer to generate a new calendar.
Just call

    $ make YEAR=2015

to generate a calendar for 2015.
You can find the generated calendar in *kalender2015.pdf*.

This call to make does nothing more than

    $ ./kalender.lua 2015 > kalender2015.tex
    $ latex kalender2015.tex
    $ dvips kalender2015.dvi
    $ ps2pdf kalender2015.ps

Enjoy your new calendar.
