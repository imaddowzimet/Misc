capture program drop unstack
program define unstack

local prefix= e(prefix)
capture assert missing(`prefix') // make sure prefix is missing
if _rc { // if it is not, use svy: code

matrix tempmatrix=e(b)'
matrix temprow=e(row)'
matrix tempcol=e(col)'
matrix tempcell=e(cell)'
local rowvar=e(rowvar)
local colvar=e(colvar)
quietly levelsof `rowvar' // count categories of variable
local numrow: word count `r(levels)' // stores number
local numrowa  `r(levels)'
quietly levelsof `colvar' // count categories of variable
local numcol: word count `r(levels)' // stores number
local numcola  `r(levels)'


* extract row names
local rownames
foreach n of local numrowa {
local name`n': label `rowvar' `n'
local rownames "`rownames' ":`name`n''""
}
local rownames "`rownames' ":Total""


* extract column names
local colnames
foreach n of local numcola {
local name`n': label `colvar' `n'
local colnames "`colnames' ":`name`n''""
}
local colnames "`colnames' ":Total""

local numcol= `numcol' +1
local numrow= `numrow' +1
foreach col of numlist 1/`numcol'{
local numrowend= `numrow'*`col'
local numrowbeg= `numrowend' - `numrow' + 1 
matrix matrix`col'= tempmatrix[`numrowbeg'..`numrowend',1]  // 
matrix row`col'= temprow[`numrowbeg'..`numrowend',1]  // 
matrix col`col'= tempcol[`numrowbeg'..`numrowend',1]  // 
matrix cell`col'= tempcell[`numrowbeg'..`numrowend',1]  // 
if `col'==1 {
matrix matrix= matrix`col'
matrix row= row`col'
matrix col= col`col'
matrix cell= cell`col'
}
else {
matrix matrix= matrix,matrix`col'
matrix row= row,row`col'
matrix col= col,col`col'
matrix cell= cell,cell`col'
}
}



capture matrix rownames row = `rownames'
if _rc {
di in red "WOOPS: Your row value labels are too long, so they've been omitted. -IMZ"
}
capture matrix rownames matrix = `rownames'
capture matrix rownames col = `rownames'
capture matrix rownames cell = `rownames'


capture matrix colnames matrix = `colnames'
capture matrix colnames row = `colnames'
if _rc {
di in red "Sorry, your column value labels are too long, so they've been omitted. -IMZ"
}
capture matrix colnames col = `colnames'
capture matrix colnames cell = `colnames'

display  "Matrix of row percentages stored in: row"
display  "Matrix of column percentages stored in: col"
display  "Matrix of cell percentages stored in: cell"
display "Matrix of current display stored in: matrix"

}
else {

matrix tempfreq=e(b)'
matrix temprow=e(rowpct)'
matrix tempcol=e(colpct)'
matrix tempcell=e(pct)'
local rowvar=e(rowvar)
local colvar=e(colvar)
quietly levelsof `rowvar' // count categories of variable
local numrow: word count `r(levels)' // stores number
local numrowa  `r(levels)'
quietly levelsof `colvar' // count categories of variable
local numcol: word count `r(levels)' // stores number
local numcola  `r(levels)'


* extract row names
local rownames
foreach n of local numrowa {
local name`n': label `rowvar' `n'
local rownames "`rownames' ":`name`n''""

}
local rownames "`rownames' ":Total""


* extract column names
local colnames
foreach n of local numcola {
local name`n': label `colvar' `n'
local colnames "`colnames' ":`name`n''""

}
local colnames "`colnames' ":Total""

local numcol= `numcol' +1
local numrow= `numrow' +1
foreach col of numlist 1/`numcol'{
local numrowend= `numrow'*`col'
local numrowbeg= `numrowend' - `numrow' + 1
matrix freq`col'= tempfreq[`numrowbeg'..`numrowend',1]  // 
matrix row`col'= temprow[`numrowbeg'..`numrowend',1]  // 
matrix col`col'= tempcol[`numrowbeg'..`numrowend',1]  // 
matrix cell`col'= tempcell[`numrowbeg'..`numrowend',1]  // 
if `col'==1 {
matrix freq= freq`col'
matrix row= row`col'
matrix col= col`col'
matrix cell= cell`col'
}
else {
matrix freq= freq,freq`col'
matrix row= row,row`col'
matrix col= col,col`col'
matrix cell= cell,cell`col'
}
}

capture matrix rownames freq = `rownames'
if _rc {
di in red "WOOPS: Your row value labels are too long, so they've been omitted. -IMZ"
}
capture matrix rownames row = `rownames'
capture matrix rownames col = `rownames'
capture matrix rownames cell = `rownames'
capture matrix colnames freq = `colnames'
if _rc {
di in red "Sorry, your column value labels are too long, so they've been omitted. -IMZ"
}
capture matrix colnames row = `colnames'
capture matrix colnames col = `colnames'
capture matrix colnames cell = `colnames'


display in blue  "Matrix of frequencies stored in: freq"
display  "Matrix of row percentages stored in: row"
display  "Matrix of column percentages stored in: col"
display  "Matrix of cell percentages stored in: cell"

}




end

exit
