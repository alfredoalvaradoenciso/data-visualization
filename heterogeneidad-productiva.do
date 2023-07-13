clear all
set more off, perma

gl enaho "C:\Users\Dell\Desktop\Bases\ENAHO"
gl img "C:\Users\Dell\Documents\GitHub\data-visualization\img"
gl result "C:\Users\Dell\Downloads"

cd "$result"

foreach a in 2007 2021 {
use "$enaho\\`a'\enaho01a-`a'-500", clear // utilizamos la enaho descargada de http://iinei.inei.gob.pe/microdatos/
drop if p500i=="00" | p500i==" 0"
keep if (p204==1 & p205==2) | (p204==2 & p206==1)
keep if ocu500==1
gen sector1r4=.
replace sector1r4=1 if p506r4>=100 & p506r4<300
replace sector1r4=2 if p506r4>=300 & p506r4<500
replace sector1r4=3 if p506r4>=500 & p506r4<1000
replace sector1r4=4 if p506r4>=1000 & p506r4<3500
replace sector1r4=5 if p506r4>=4100 & p506r4<4500
replace sector1r4=6 if p506r4>=4500 & p506r4<4900
replace sector1r4=7 if p506r4>=8400 & p506r4<8500
replace sector1r4=8 if (p506r4>=3500 & p506r4<4100) | (p506r4>=4900 & p506r4<8400) | (p506r4>=8500 & p506r4<=9900)
lab def sector1r4 1 "Agricultura"  2 "Pesca y acuicultura" 3 "Minería" ///
4 "Industrias manufactureras" 5 "Construcción" ///
6 "Comercio" 7 "Servicios gubernamentales" 8 "Otros servicios" 
lab val sector1r4 sector1r4 
lab var sector1r4 "Sectores económicos"
collapse (sum) ocu500 [iw=fac500a], by(sector1)
egen Semptot=pc(ocu500)
gen cat=sector1+1
drop sector1
gen anio=`a'
tempfile enaho`a'
save `enaho`a''
}
*
use `enaho2007', clear
append using `enaho2021'
tempfile enaho
save `enaho'

import excel "$result\pbi_act_econ_n9_kte_1950-2022.xlsx", clear sheet("MillonesSoles") cellrange(A7:K79) // utilizamos un excel del INEI descargado de https://www.inei.gob.pe/estadisticas/indice-tematico/economia/
replace K=G+K
drop B G
replace A="2021" if A=="2021P/"
replace A="2022" if A=="2022E/"
destring A, replace

local j = 1
foreach v of varlist  _all {
rename `v' A`j'
local j= `j'+1
}
rename A1 anio
reshape long A, i(anio) j(cat)
gen sector=""
local etiquetas Agricultura	Pesca	Minería Manufactura	Construcción 	Comercio	"Servicios Gubernamentales"	"Otros servicios"
local j = 2
foreach i of local 	etiquetas {		
replace sector="`i'" if cat==`j'
local j = 1 + `j'
}

keep if anio==2007 | anio==2021 
merge 1:1 anio cat using `enaho'
drop cat
gen lprodtot=A*1000000/ocu500
drop  A _m ocu500
*tostring year, replace
expand round(Semptot*10000,1)


sort anio lprodtot 
bys anio: gen p_emp=(_n-1)/100
sort anio sector p_emp
bys anio sector: egen aux_meanpemp=mean(p_emp)
gen aux_one=1 if p_emp>=aux_meanpemp 
bys anio sector aux_one: gen aux_label=1 if _n==1
replace aux_label=. if aux_label!=aux_one
gen label_sector=sector if aux_label!=.
sort anio p_emp
replace p_emp=p_emp/100

sort sector anio p_emp
by sector anio: g quedar= _n==1 | _n==_N
keep if quedar!=0

replace label_sector=sector if anio==2013 & aux_one==1
sort anio p_emp
replace lprodtot=lprodtot/1000

set scheme s1color
graph twoway (line lprodtot p_emp if anio==2007) ///
	(scatter lprodtot p_emp if anio==2021  ,   c(l) msymbol(none)  ) ///
	(pcarrowi 50 40 29.04 46) ///
	(pcarrowi 77 44 37.04 50) ///
	(pcarrowi 98 54 47.04 57) ///
	(pcarrowi 80 85 55.04 92) ///
	, ylabel(0(30)280,angle(0)) ///
	title("Peru: Evolucion de la productividad," "por sectores, 2007-2021") ///
	note("Fuente: ENAHO, INEI.", size(*1) justification(left) position(7))  ///
	ytitle("Valor Agregado por trabajador" "(Miles de nuevos soles de 2007)") /// 
	xtitle("% acumulado de la fuerza laboral") 	///
	text(22 10 "Agropecuario", 	color(black)) ///
	text(32 32.9799 "Comercio",  color(black)) ///
	text(62 35.4099 "Pesca",  color(black)) ///
	text(90 38.4099 "Construccion", color(black)) ///		
	text(110 50.4099 "Sector público",  color(black)) ///
	text(60 70.4099 "Otros Servicios",color(black)) ///
	text(89 80.4099 "Manufactura", color(black)) ///	
	text(260 90.4099 "Minería", color(black)) ///
	legend(order(1 "2007" 2 "2021") )
graph export  "$img\grafico_heterogenidad4.png",replace
