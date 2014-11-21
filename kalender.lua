#!/usr/bin/env lua
-- vim: set ts=4 sw=4 tw=78 et si:
--
-- kalender.lua - generate exercise calendars
--
-- usage: lua kalendar.lua [year] > calendar.tex
--        latex calendar
--        dvips calendar
--        ps2pdf calendar.ps

-- day offset of first per month in normal year and leap year
nydayoffset = { 0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334, 365 }
lydayoffset = { 0, 31, 60, 91, 121, 152, 182, 213, 244, 274, 305, 335, 366 }

weeks       = 53

-- determine the year for which a calendar should be generated
if 0 == #arg then
    year = os.date('%Y',os.time())
else
    year = arg[1]
end

-- determine whether this is a leap year
downewyear  = 0 + os.date('%w',os.time({year=year, month=1, day=1}))
dowmarch1st = 0 + os.date('%w',os.time({year=year, month=3, day=1}))
dowdiff = math.mod(7 + dowmarch1st - downewyear, 7)

if (3 == dowdiff) then
    dayoffset = nydayoffset
elseif (4 == dowdiff) then
    dayoffset = lydayoffset
    if (0 == downewyear) then
        weeks = 54
    end
else
    print("I'm too dumb to calculate if this is a leap year or not")
    os.exit(1)
end

-- on years starting with monday the left dark vertical line starts at the top
if 1 == downewyear then
    leftvertical = '\\psline(0,53)(0,0)'
else
    leftvertical = '\\psline(0,' .. (weeks - 1) .. ')(0,0)'
end

-- on years ending with sunday the left dark vertical line ends at the bottom
if 1 == math.mod(downewyear + dayoffset[13],7) then
    rightvertical = '\\psline(7,53)(7,0)'
else
    rightvertical = '\\psline(7,' .. weeks .. ')(7,1)'
end

-- this function creates the dark lines between two months
function horizontal_line(monthno, weeks, downewyear, dayoffset)
    local ul = weeks - math.ceil(dayoffset[monthno]/7)
    local fd = math.mod(dayoffset[monthno] + downewyear,7)
    if 0 == fd then
        fd = 7
    end
    if (0 < downewyear) and (fd > downewyear) then
        ul = ul + 1
    end
    if 1 == fd then
        return '\\psline(0,' .. ul .. ')(7,' .. ul .. ')'
    end
    return '\\psline(0,'
        .. ul - 1
        ..')('
        .. fd - 1
        .. ','
        .. ul - 1
        .. ') \\psline('
        .. fd - 1
        .. ','
        .. ul - 1
        .. ')('
        .. fd - 1
        .. ','
        .. ul
        .. ') \\psline('
        .. fd - 1
        .. ','
        .. ul
        .. ')(7,'
        .. ul
        .. ')'
end

-- this latextemplate contains the parts which are identical for each calendar
latextemplate = [[
%% calendar-\CALyear.tex - generated with kalender.lua
\documentclass{article}
\usepackage{pstricks}
\usepackage{multido}
\psset{unit=.40cm}
\psset{gridlabelcolor=white}
\psset{gridcolor=lightgray}
\pagestyle{empty}
\begin{document}
 \begin{figure}
  \begin{pspicture}(30,1)
   \rput(2,3){\huge \CALyear}
   \psline(9,2)(34,2)
  \end{pspicture}
  \\
\begin{pspicture}(7,1)%
\rput(0.5,1){M}
\rput(1.5,1){D}
\rput(2.5,1){M}
\rput(3.5,1){D}
\rput(4.5,1){F}
\rput(5.5,1){S}
\rput(6.5,1){S}
\end{pspicture}%
\\
\begin{pspicture}(7,\CALweeks)%
   \psgrid[subgriddiv=1](7,\CALweeks)
   \CALleftvertical
   \CALrightvertical
   \CALhorizontalline1
   \CALhorizontalline2
   \CALhorizontalline3
   \CALhorizontalline4
   \CALhorizontalline5
   \CALhorizontalline6
   \CALhorizontalline7
   \CALhorizontalline8
   \CALhorizontalline9
   \CALhorizontalline10
   \CALhorizontalline11
   \CALhorizontalline12
   \CALhorizontalline13
\end{pspicture}%
\begin{pspicture}(2,\CALweeks)
\end{pspicture}%
\begin{pspicture}(25,\CALweeks)
   \psset{linecolor=lightgray}
   \multido{\iy=0+1}{\CALweeks}{%
   \psline(0,\iy)(25,\iy)%
   }
\end{pspicture}
\end{figure}
\end{document}
]]

-- substitute the parts that are different for each year
latextemplate = string.gsub(latextemplate,'\\CALweeks', weeks)
latextemplate = string.gsub(latextemplate,'\\CALyear', year)
latextemplate = string.gsub(latextemplate,'\\CALleftvertical', leftvertical)
latextemplate = string.gsub(latextemplate,'\\CALrightvertical', rightvertical)
for hl = 13, 1, -1 do
    latextemplate = string.gsub(latextemplate
                               ,'\\CALhorizontalline' .. hl
                               , horizontal_line(hl,weeks,downewyear,dayoffset))
end

-- now print that calendar
print(latextemplate)
