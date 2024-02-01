frause oaxaca, clear
set seed 101
hetreg lnwage age agesq married divorced kids6 kids714 if female==0, het(age agesq married divorced kids6 kids714)
predict xb0, xb
predict s0, sigma
hetreg lnwage age agesq married divorced kids6 kids714 if female==1, het(age agesq married divorced kids6 kids714)
predict xb1, xb
predict s1, sigma

gen lnwage1 = rnormal(xb0,s0)
gen lnwage0 = rnormal(xb1,s1)

** base wage lnwage0
gen teff=lnwage1-lnwage0

** Randomization
gen trt = runiform()<.5

** Realization

replace lnwage = lnwage0 + trt * teff

** Estimation Treatment effect
** True ATE

sum teff
reg lnwage  trt, robust
est sto m0
** Add controls

reg lnwage  trt age agesq , robust
est sto m1
reg lnwage  trt age agesq married divorced , robust
est sto m2
reg lnwage  trt age agesq married divorced kids6 kids714 , robust
est sto m3

esttab m0 m1 m2 m3, se nonum mtitle("m0" "m1" "m2" "m3")

** Falsification 

reg exper  trt age agesq married divorced kids6 kids714 , robust
est sto m0
reg tenure trt age agesq married divorced kids6 kids714 , robust
est sto m1

** Balance test
tabstat age agesq married divorced kids6 kids714 , by(trt)
sureg age agesq married divorced kids6 kids714 =trt, isure
