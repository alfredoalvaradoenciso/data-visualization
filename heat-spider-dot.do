gl root "C:\Users\Dell\Downloads\graphswbg"
gl img "C:\Users\Dell\Documents\GitHub\data-visualization\img"

cd "$root"

*HEAT PLOT
global y2 "2021"
global vars "cce gee pve rqe rle vae"
use "$root\WGI2", clear
drop if _pop<500000
keep if year==$y2
drop year
keep if code2==1

local i =1
foreach v of varlist $vars  {
rename `v' value`i'
local i = `i'+1
}
egen mean=rowmean(value*)
sort mean
gen col=_n
labmask col, val(code)
keep col value*

reshape long value, i(col ) j(vars)
lab def vars 1 "Control of Corruption" 2 "Gov. Effectiveness" 3 "Pol. Stability" 4 "Regulatory Quality" 5 "Rule of Law" 6 "Voice & Accountability", modify
label val vars vars
levelsof col, local(col_levels)       
	 foreach val of local col_levels {   
      	 local colvl`val' : label col `val'    
       }
keep var value col
sort value
reshape wide value, i(var) j(col)
	 foreach value of local col_levels{        
		 rename value`value' `colvl`value''
	 }
	 
mkmat VEN-URY, matrix(A)
mat rownames A = "Control of Corruption" "Government Effectiveness" "Political Stability" "Regulatory Quality" "Rule of Law" "Voice & Accountability"
heatplot A,  color(, intensity(.7)) nolabel xlabel(,angle(90))  graphregion(color(white))   aspectratio(0.4) levels(8) legend(off) name(a, replace)
graph combine a, title(Heat plot of governance indicators in LAC countries) note("Source: Worldwide Governance Indicators. Note: Countries with darker colors are worse off.") graphregion(color(white)) 
graph export "$img\heat.png", replace



*SPIDER GRAPH
global y2 "2021"
global weight "[iw=1]"
global vars "ccr ger pvr rqr rlr var"
use "$root\WGI2", clear
keep if year==$y2
preserve
collapse (mean) $vars $weight
gen Region="World"
gen code2=3
gen code2e=3
tempfile world
save `world'
restore
keep if code2<5 | code2==6
preserve
collapse (mean) $vars (count) own=vae $weight , by(code2e)
tempfile e
save `e'
restore
collapse (mean) $vars (count) own=vae $weight , by(Region code2)
list code2 own 
append using `world'
append using `e'
drop Region code2 own
drop if code2e==.
local i =1
foreach v of varlist $vars  {
rename `v' value`i'
local i = `i'+1
}
reshape long value, i(code2) j(a)
reshape wide value, i(a) j(code2)
lab def a 1 "Control of Corruption" 2 "Gov. Effectiveness" 3 "Pol. Stability" 4 "Regulatory Quality" 5 "Rule of Law" 6 "Voice & Accountability", modify
label val a a
decode a, gen(vars)
rename (value*) (LAC EAP World ECA SSA)
gen id=_n
replace id=7 if vars=="Regulatory Quality"
replace id=4 if vars=="Voice & Accountability"
sort id
radar vars LAC EAP World ECA, title("Percentile Rank (0=lowest rank, 100=highest rank), $y2") lc(red navy forest_green dkorange) lp(solid dash shortdash solid) lw(*2 *2 *2 *2)  graphregion(color(white))  r(30 30 40 50 60)  aspect(0.6) legend(order(1 "LAC" 2 "EAP" 3 "World" 4 "ECA") rows(1))    note("Source: Worldwide Governance Indicators")
graph export "$img\spider.png", replace


** DOT GRAPH

global weight "[iw=_pop_2]"
global weight "[iw=1]"
global y1 "2010"
global y2 "2020"
global y3 "2014"
use "$root\countrieswdi2", clear
lookfor "Gini index o"
global value="`r(varlist)'"
preserve
collapse (mean) own=$value $weight, by(year)
gen codelac=1
tempfile world
save `world'
restore
preserve
collapse (mean) own=$value  $weight , by(year code2)
gen codelac=2 if code2==4
replace codelac=3 if code2==2
replace codelac=4 if code2==1
drop code2
tempfile lac
save `lac'
restore
collapse (mean) own=$value $weight, by(codelac year)
append using  `world'
append using  `lac'
drop if codelac==.
drop if codelac==5
replace own=own
gen a=own if codelac==8 & year==2011
egen a2=min(a)
replace own=a2 if own==. & codelac==8 & year==2010
drop a a2 
keep if (year==$y1 | year==$y2 | year==$y3)
reshape wide own, i(codelac) j(year)
local value2 `"Index from 0=equality to 100=inequality"'
local value3 "Gini index"
local value4 `""Source: World Development Indicators. Note: Initial value of Brazil is in 2011""'
lab def codelac 1 "World" 2 "EAP" 3 "ECA" 4 "LAC" 5 "Caribbean" 6 "Central America" 7 "Mexico" 8 "Brazil" 9 "South Cone" 10 "Andean countries", modify
#delimit ;
twoway rspike own$y1 own$y2 codelac,       
horizontal ylab(1 2 3 4 6 7 8 9 10, val angle(0)) legend(order(2 "$y1" 3 "$y3" 4 "$y2") rows(1))     ||
scatter codelac own$y1 || 
scatter codelac own$y3 ||
scatter codelac own$y2	, msymbol(D) legend(ring(0) position(4)) xlabel(,grid)
ytitle("")  xtitle(`value2') title(`value3') note(`value4') graphregion(color(white)) 
;
#delimit cr
graph export "$img\dot.png", replace

