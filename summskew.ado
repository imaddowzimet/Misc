capture program drop summskew
program define summskew                 

syntax varname[, by(varname)]             

capture confirm variable `by'
if _rc {
quietly summarize `varlist', detail
capture gen n = r(N)
capture gen skew = r(skewness)
capture gen seskew = sqrt((6*(n)*(n - 1))/((n - 2)*(n + 1)*(n + 3)))
capture gen skew_ratio = skew/seskew
display "skewness = " skew "; seskew = " seskew " ; skewness ratio = " skew_ratio

}
else {

qui {                               
summarize `by', detail
display "the maximum code for the grouping variable = " r(max)
display "the minimum code for the grouping variable = " r(min)
global k = r(max)
global m = r(min)
}

forval i = $m (1) $k {
qui {
summarize `varlist' if `by' == `i', detail
capture drop n skew seskew skew_ratio
gen n = r(N)
gen skew = r(skewness)
gen seskew = sqrt((6*(n)*(n - 1))/((n - 2)*(n + 1)*(n + 3)))
gen skew_ratio = skew/seskew
}
display "For `by' = " `i' ": skewness = " skew "; seskew = " seskew " ; skewness ratio = " skew_ratio "
display ""                        
}
}
end
exit
