capture program drop skewanova
program define skewanova                 

syntax varlist(min=3 max=3)

local var1: word 1 of `varlist'
local var2: word 2 of `varlist'
local var3: word 3 of `varlist'

summarize `var2', detail
display "maximum number of groups = " r(max)
display "minimum number of groups = " r(min)
global k1 = r(max)
global m1 = r(min)
summarize `var3', detail
display "maximum number of groups = " r(max)
display "minimum number of groups = " r(min)
global k2 = r(max)
global m2 = r(min)
forval i = $m1 (1) $k1 {
forval j = $m2 (1) $k2 {
quietly summarize `var1' if `var2'== `i' & `var3' == `j', detail
capture drop n skew seskew skew_ratio
gen n = r(N)
gen skew  = r(skewness)
gen seskew  = sqrt((6*(n)*(n - 1))/((n - 2)*(n + 1)*(n + 3)))
gen skew_ratio = skew/seskew
display "For `var2' = " `i' " and `var3' = " `j' ": N = " n "; skewness = " skew "; seskew = " seskew " ; skewness ratio = " skew_ratio
}
}



end
exit
