///Title: Depths of Despair
///Author: Lauren Gaydosh
///Date: September 11, 2017
///Updated: November 7, 2017 - to include preliminary Wave V Sample 1 data
///Updated: January 22, 2018 - to include final sample 1 data and weights
///Updated: May 2, 2018 - to include waves I and III outcomes
///Updated: October 22, 2018 - to respond to AJPH reviews, to include full sample rather than those only at wave V
///Updated: Noveber 14, 2018 - to include Wave II

clear all
set maxvar 10000
set more off

***Start with Wave I and Wave IV data
clear all
import sasxport "D:\ahd\adhealth\wave1\allwave1.xpt" 
tempfile despair
save `despair'

clear all
import sasxport "D:\ahd\adhealth\wave4\wave4.xpt" 
mmerge aid using `despair'

*Education 4 categories
gen w4education = h4ed2 if h4ed2 <96
recode w4education 1/2=1 3=2 4/6=3 7/13=4
tab w4education

gen w4education3cat=w4education
recode w4education3cat 1/2=1 3=2 4=3

gen collegeplus=w4education
recode collegeplus 1/3=0 4=1

gen somecollege=w4education
recode somecollege 1/2=0 3/4=1

gen w4educationcont=h4ed2 if h4ed2 <96
recode w4educationcont 11/13=11


*********CONTROLS**********

***Age***
* Wave 1 age
recode h1gi1m (96=.), gen (w1bmonth)
recode h1gi1y (96=.), gen (w1byear)
gen w1bdate = mdy(w1bmonth, 15,1900+w1byear)
format w1bdate %d
gen w1idate=mdy(imonth, iday,1900+iyear)
format w1idate %d
gen w1age=int((w1idate-w1bdate)/365.25)
tab w1age

* Wave 4 age
gen w4idate=mdy(imonth4, iday4,iyear4)
format w4idate %d
gen w4age=int((w4idate-w1bdate)/365.25)
tab w4age


***Sex***
gen female =bio_sex
**Recode so male =0, female=1
recode female 1=0 2=1 6/8=.
tab female


***Race 6 category (code from Add Health resource)
gen race=.
/* White, Non-Hispanic */ 
replace race=1 if h1gi6a==1
/* Black or African American, Non-Hispanic */ 
replace race=2 if h1gi6b==1
/* Native American, Non-Hispanic */ 
replace race=3 if h1gi6c==1
/* Asian, Non-Hispanic */ 
replace race=4 if h1gi6d==1
/* Other, Non-Hispanic */ 
replace race=5 if h1gi6e==1
/* Hispanic, All Races */ 
replace race=6 if h1gi4==1
label define racelbl 1 "White" 2 "Black" 3 "Nat Amer" 4 "Asian" 5 "Other" 6 "Hispanic"
label values race racelbl
tab1 race

**Race 4 category
gen race4cat = race
recode race4cat 1=1 2=2 6=3 3/5=4
label define race4catlbl 1 "White" 2 "Black" 3 "Hispanic" 4 "Other"
label values race4cat race4catlbl
tab1 race4cat

**Race dichotomous
gen nonwhite = race
recode nonwhite 1=0 2/6=1
tab nonwhite

**All race dummies
gen white=0
replace white=1 if h1gi6a==1
gen black=0
replace black=1 if h1gi6b==1
gen nativeamer=0
replace nativeamer=1 if h1gi6c==1
gen asian=0
replace asian=1 if h1gi6d==1
gen other=0
replace other=1 if h1gi6e==1
gen hispanic=0
replace hispanic=1 if h1gi4==1
tab1 white black nativeamer asian other hispanic

gen other2=0
replace other2=1 if nativeamer==1 | asian==1 | other==1
tab1 white black other2 hispanic

gen racebw=race4cat
recode racebw 1=0 2=1 3/4=.

**Immigrant
gen immigrant=h1gi11
recode immigrant 7=0 0=1 1=0 6=. 8=.

 **Currently pregnant
gen currentlypreg = h4tr7
recode currentlypreg 7=0 6=. 8=.
tab currentlypreg

***
gen blackwhite = 1 if race4cat==1 | race4cat==2

gen hispwhite = 0 if race4cat==1 | race4cat==3

gen suattemptw4 = 0 if h4se2==0
replace suattemptw4 = 1 if h4se2>0 & h4se2!=.

gen suinjury = 0 if h4se3==0 | h4se3==7
replace suinjury = 1 if h4se3==1

///keep variables we need
keep aid  h4id5h h4id5j  h4mh18 h4mh19 h4mh21  h4mh22 h4mh26 h4mh18 h4mh19 h4mh20 h4mh21 h4mh22 ///
h4mh23 h4mh25 h4mh26 h4mh24 h4mh27 h4id6j  h4pe6* h4pe14 h4pe22* h4pe30  h4pe7* ///
h4pe15 h4pe23* h4pe31 h4se1  h4to51 h4to58  h4to46 ///
h4to47 h4to48 h4to49 h4to50  h4to51 h4to52 h4to53  h4to55 h4to56 h4to58 h4to59 h4to60 ///
h4to61  h4to81 h4to88  h4to76 h4to77 ///
h4to78 h4to79 h4to80  h4to81 h4to82 h4to83  h4to85  h4to86 h4to88 h4to89 h4to90  ///
h4to91  h4to109 h4to116  h4to104 h4to105 ///
h4to106 h4to107 h4to108  h4to109 h4to110 h4to111 h4to113 h4to114 h4to116 h4to117 h4to118 ///
h4to119 h4to63 h4to64a h4to64b h4to64c h4to64d h4gh1  h4to35 h4to39 h4to40 h4to37 ///
bio_sex race* imonth4 iday4 iyear4 w4age w4education-suinjury ///
h4to*    h1fs1 h1fs3 h1fs4 h1fs5 h1fs6 h1fs7 h1fs11 h1fs15 h1fs16 h1fs17 h1su1 h1to42 h1to36 h1to46 h1to15 ///
h1to17 h1gh1  h1to30 h1to31 h1to32 h1to3 h1to7  scid

save "D:\ahd\researchers\lgaydosh\keep\Despair\WaveIIV", replace

use "D:\ahd\researchers\lgaydosh\keep\Despair\WaveIIV", clear

///merge wave IV constructed variables
tempfile despair
save `despair'
clear all
import sasxport "D:\ahd\adhealth\wave4\w4vars.xpt"
mmerge aid using `despair'

///merge in Wave III despair indicators
tempfile despair
save `despair'
clear all
import sasxport "D:\ahd\adhealth\wave3\wave3.xpt" 
keep aid h3sp5 h3sp6 h3sp7 h3sp8 h3sp9 h3sp10 h3sp11 h3sp12 h3sp13 ///
h3to130 h3to119 h3gh1 h3to110 h3to4 h3to10 h3to40 h3to39 imonth3 iday3 iyear3 h3ed1
mmerge aid using `despair'

///merge in Wave II despair indicators
tempfile despair
save `despair'
clear all
import sasxport "D:\ahd\adhealth\wave2\wave2.xpt" 
keep aid h2fs1 h2fs3 h2fs4 h2fs5 h2fs6 h2fs7 h2fs11 h2fs15 h2fs16 h2fs17 h2su1  h2to19 h2to20 h2to21 ///
h2to46 imonth2 iyear2 iday2
mmerge aid using `despair'


///merge in Sample 1 Wave V data
tempfile despair
save `despair'
clear all
import sasxport  "D:\ahd\adhealth\wave5\wave5_s1.xpt"
mmerge aid using `despair'

///merge in Sample 1 Wave V weights
tempfile despair
save `despair'
clear all
import sasxport  "D:\ahd\adhealth\wave5\wgtsw5s1.xpt"
mmerge aid using `despair'

///Wave IV census tract information
tempfile despair
save `despair'
clear all
import sasxport "D:\ahd\adhealth\wave4\TRACT4.xpt"
keep aid ter00156 ter00157 tac09052 ///
tac09075 tac09076 tac09077 tac09078 tac09079 tac09080 tac09081 tac09082 tac09083 tac09084 ///
tac09085 tac09086 tac09087 tac09088 tac09089 tac09090 tac09091 tac09092 tac09093
mmerge aid using `despair'
xtile manufact=tac09077, nq(4)
xtile unemploy4 = tac0905, nq(4)
drop _merge 

///merge in wave I weights
tempfile despair
save `despair'
clear all
import sasxport "D:\ahd\adhealth\wave1\w1homewc.xpt"
merge 1:1 aid using `despair'

save "D:\ahd\researchers\lgaydosh\keep\Despair\181022_DespairData", replace


use "D:\ahd\researchers\lgaydosh\keep\Despair\181022_DespairData", clear

////////////CONSTRUCT PARALLEL MEASURES BETWEEN WAVES IV AND V WHEN POSSIBLE

* Wave II age
replace iyear2 = iyear2+1900
gen w2idate=mdy(imonth2,iday2,iyear2)
format w2idate %d
gen w2age=int((w2idate-w1bdate)/365.25)
tab w2age

* Wave III age
gen w3idate=mdy(imonth3, iday3,iyear3)
format w3idate %d
gen w3age=int((w3idate-w1bdate)/365.25)
tab w3age

* Wave V age
gen w5idate=mdy(imonth5, iday5,iyear5)
format w5idate %d
gen w5age=int((w5idate-w1bdate)/365.25)
tab w5age

gen wave1 = 0
replace wave1 = 1 if w1age!=.

gen wave2 = 0 
replace wave2 = 1 if w2age!=.

gen wave3 = 0 
replace wave3 = 1 if w3age!=.

gen wave4 = 0
replace wave4 = 1 if w4age!=.

gen wave5 = 0 
replace wave5 = 1 if w5age!=.

///depression diagnosis
tab h4id5h
gen dxdepress4 = h4id5h if h4id5h < 6 & wave4==1

tab h5id6g
gen dxdepress5 = h5id6g & wave5==1
recode dxdepress5 2=0

///depressive symptoms - 4 items at waves I, IV and V
///wave III missing one question

gen depress1_1 = h1fs3 if h1fs3 < 6 & wave1==1
gen depress1_2 = h1fs6 if h1fs6 < 6 & wave1==1
gen depress1_3 = h1fs11 if h1fs11 < 6 & wave1==1
gen depress1_4 = h1fs16 if h1fs16 < 6 & wave1==1

recode depress1_3 0=3 1=2 2=1 3=0
gen depress1 = depress1_1 + depress1_2 + depress1_3 + depress1_4 if wave1==1

gen depress2_1 = h2fs3 if h2fs3 < 6 & wave2==1
gen depress2_2 = h2fs6 if h2fs6 < 6 & wave2==1
gen depress2_3 = h2fs11 if h2fs11 < 6 & wave2==1
gen depress2_4 = h2fs16 if h2fs16 < 6 & wave2==1

recode depress2_3 0=3 1=2 2=1 3=0
gen depress2 = depress2_1 + depress2_2 + depress2_3 + depress2_4 if wave2==1

gen depress3_1 = h3sp6 if h3sp6 < 6 & wave3==1
gen depress3_2 = h3sp9 if h3sp9 < 6 & wave3==1
gen depress3_3 = h3sp11 if h3sp11 < 6	& wave3==1 //this is enjoyed life rather than felt happy
gen depress3_4 = h3sp12 if h3sp12 < 6 & wave3==1

recode depress3_3 0=3 1=2 2=1 3=0
gen depress3 = depress3_1 + depress3_2 + depress3_3 + depress3_4  if wave3==1

gen depress4_1 = h4mh19 if h4mh19 <6 & wave4==1
gen depress4_2 = h4mh22 if h4mh20 <6 & wave4==1
gen depress4_3 = h4mh24 if h4mh21 <6 & wave4==1
gen depress4_4 = h4mh26 if h4mh22 <6 & wave4==1

recode depress4_3 0=3 1=2 2=1 3=0

gen depress4 = depress4_1 + depress4_2 + depress4_3 + depress4_4 if wave4==1

alpha depress4_1 depress4_2 depress4_3 depress4_4 

gen depress5_1 = h5ss0a - 1 if h5ss0a <6 & wave5==1
gen depress5_2 = h5ss0b - 1 if h5ss0b <6 & wave5==1
gen depress5_3 = h5ss0c - 1 if h5ss0c <6 & wave5==1
gen depress5_4 = h5ss0d - 1 if h5ss0d <6 & wave5==1

recode depress5_3 0=3 1=2 2=1 3=0

gen depress5 = depress5_1 + depress5_2 + depress5_3 + depress5_4  if wave5==1

alpha depress5_1 depress5_2 depress5_3 depress5_4 

///anxiety diagnosis 
tab h4id5j
tab h5id6i
gen dxanxiety4 = h4id5j if h4id5j<2 & wave4==1
gen dxanxiety5 = h5id6i if wave5==1


///optimism - 3 items at waves IV and V
gen opt4_1 = h4pe7 if h4pe7<6
gen opt4_2 = h4pe15 if h4pe15<6
gen opt4_3 = h4pe23 if h4pe23<6
recode opt4_2 1=5 2=4 4=2 5=1
gen optimism4 = opt4_1 + opt4_2 + opt4_3
alpha opt4_1 opt4_2 opt4_3

gen opt5_1 = h5pe1 if h5pe1<6
gen opt5_2 = h5pe2 if h5pe2<6
gen opt5_3 = h5pe3 if h5pe3<6
recode opt5_2 1=5 2=4 4=2 5=1
gen optimism5 = opt5_1 + opt5_2 + opt5_3
alpha opt5_1 opt5_2 opt5_3

///suicidal ideation
tab h1su1
tab h3to130
tab h4se1
tab h5mn8
gen suicide1 = h1su1 if h1su1<6 & wave1==1
gen suicide2 = h2su1 if h2su1<6 & wave2==1
gen suicide3 = h3to130 if h3to130<6 & wave3==1
gen suicide4 = h4se1 if h4se1<6  & wave4==1
gen suicide5 = h5mn8 if wave5==1


///Marijuana Use - any use in the last 30 days
tab h1to32 
tab h2to46
tab h3to110
tab h4to71
tab h5to21

gen marijuana1 = 0 if  wave1==1
replace marijuana1 = 1 if h1to32>0 & h1to32<96 

gen marijuana2 = 0 if  wave2==1
replace marijuana2 = 1 if h2to46>0 & h2to46<996

gen marijuana3 = 0 if wave3==1
replace marijuana3 = 1 if h3to110>0 & h3to110<96 

gen marijuana4 = 0 if wave4==1
replace marijuana4 = 1 if h4to71>0 & h4to71<96 

gen marijuana5 = 0 if wave5==1
replace marijuana5 = 1 if h5to21 >1 & h5to21<97 


///any binge drinking in last year 
tab h1to17
tab h2to21
tab h3to40
tab h4to37
tab h5to15

gen binge1 = 0 if wave1==1
replace binge1 = 1 if h1to17>1 & h1to17<7

gen binge2 = 0 if wave2==1
replace binge2 = 1 if h2to21>1 & h2to21<7

gen binge3 = 0 if wave3==1
replace binge3 = 1 if h3to40>1 & h3to40<96

gen binge4 = 0  if wave4==1
replace binge4 = 1 if h4to37>1 & h4to37<96

gen binge5 = 0 if wave5==1
replace binge5 = 1 if h5to15>2 & h5to15<97

///Alcohol use - heavy use in the last 30 days
tab h4to39
tab h5to13
tab h4to40
tab h5to14

gen alcohol4 = h4to40 if h4to40<95
replace alcohol4 = 0 if alcohol4==.
gen riskydrinking4 = 0
replace riskydrinking4 = 1 if alcohol4>4 & female==1
replace riskydrinking4 = 1 if alcohol4>5 & female==0

gen alcohol5 = h5to14 if h5to14<97
replace alcohol5 = 0 if alcohol5==.
gen riskydrinking5 = 0
replace riskydrinking5 = 1 if alcohol5>4 & female==1
replace riskydrinking5 = 1 if alcohol5>5 & female==0

///prescription drug use
tab h4to64a h5to26a
replace h4to64a = 0 if h4to64a==7
gen sedatives = 0 if h4to64a==0 & h5to26a==0
replace sedatives = 1 if h4to64a==0 & h5to26a==1
replace sedatives = 2 if h4to64a==1 & h5to26a==0
replace sedatives = 3 if h4to64a==1 & h5to26a==1

tab h4to64b h5to26b
replace h4to64b = 0 if h4to64b==7
gen tranqs = 0 if h4to64b==0 & h5to26b==0
replace tranqs = 1 if h4to64b==0 & h5to26b==1
replace tranqs = 2 if h4to64b==1 & h5to26b==0
replace tranqs = 3 if h4to64b==1 & h5to26b==1

tab h4to64c h5to26c
replace h4to64c = 0 if h4to64c==7
gen stims = 0 if h4to64c==0 & h5to26c==0
replace stims = 1 if h4to64c==0 & h5to26c==1
replace stims = 2 if h4to64c==1 & h5to26c==0
replace stims = 3 if h4to64c==1 & h5to26c==1

tab h4to64d h5to26d
replace h4to64d = 0 if h4to64d==7
gen painpills = 0 if h4to64d==0 & h5to26c==0
replace painpills = 1 if h4to64d==0 & h5to26d==1
replace painpills = 2 if h4to64d==1 & h5to26d==0
replace painpills = 3 if h4to64d==1 & h5to26d==1

///Illegal drug use
tab h4to65c h5to27a
gen cocaine = 0 if h4to65c==0 & h5to27a==0
replace cocaine = 1 if h4to65c==0 & h5to27a==1
replace cocaine = 2 if h4to65c==1 & h5to27a==0
replace cocaine = 3 if h4to65c==1 & h5to27a==1

tab h4to65d h5to27b
gen meth = 0 if h4to65d==0 & h5to27b==0
replace meth = 1 if h4to65d==0 & h5to27b==1
replace meth = 2 if h4to65d==1 & h5to27b==0
replace meth = 3 if h4to65d==1 & h5to27b==1

tab h4to65e h5to27d
gen otherillegal = 0 if h4to65e==0 & h5to27d==0
replace otherillegal = 1 if h4to65e==0 & h5to27d==1
replace otherillegal = 2 if h4to65e==1 & h5to27d==0
replace otherillegal = 3 if h4to65e==1 & h5to27d==1

///self-rated health
sum h1gh1 
sum h3gh1
sum h4gh1
sum h5id1

***Wave V sex
gen male = 1 if h5od2==1
replace male = 0 if h5od2==2

***Wave V education
gen w5educ_4cat = h5od11
recode w5educ_4cat 1/4 = 1 5/9 = 2 10 = 3 11/16=4	//HS or less, some college, college, more than college
gen w5_collegeplus = 0 if h5od11<10
replace w5_collegeplus = 1 if h5od11>=10
gen w5_hsless = 1 if h5od11<5 & h5od11!=.
replace w5_hsless = 0 if h5od11>=5  & h5od11!=.

***Wave IV education
gen w4_hsless = 1 if w4education <3  & w4education!=.
replace w4_hsless = 0 if w4education>2 & w4education!=.
replace w4_hsless = w5_hsless if w4_hsless==. & w5_hsless!=.

***Wave III education
gen w3_hsless = 1 if h3ed1 <13 & h3ed1!=. 
replace w3_hsless = 0 if h3ed1>12 & h3ed1<23 & h3ed1!=.
replace w4_hsless = w3_hsless if w4_hsless==. & w3_hsless!=.

///

save cross_sectional_dataset, replace

***Reshape to long to analyze longitudinal - waves 1, 3, 4, 5
keep aid psuscid region gswgt5_2 gswgt145 schwt1 w1_wc female race4cat depress1 depress2 depress3 depress4 depress5 ///
marijuana1-marijuana5 binge1-binge5 suicide1-suicide5 ///
w1age w2age w3age w4age w5age w5_collegeplus collegeplus w4_hsless  ///
tac09052 tac09077 ter00156 manufact unemploy4   w1bdate w1byear

rename w1age age1
rename w2age age2
rename w3age age3
rename w4age age4
rename w5age age5


reshape long age depress marijuana binge suicide, i(aid)
gen wave = _j
***
/* WEIGHTS - NEED TO FIGURE OUT HOW TO INCORPORATE IN ML MODELS
* Set longitudinal Wave V Sample 1 weights
drop if gswgt145 ==.
**Wave IV weights (for education models)
svyset psuscid [pweight=gswgt145], strata(region) 
|| aid 

svyset psuscid, weight(schwt1) strata(region) || aid, weight(gswgt145)

svyset psuscid, weight(schwt1) strata(region) || aid, weight(w1_wc)
*/

///restrict to white, black and hispanic
gen subanalytic = 1 if race4cat!=4
destring aid, replace


save analytic_dataset, replace


use "D:\ahd\researchers\lgaydosh\keep\Despair\analytic_dataset", clear

gen subpopwhite = 0 if subanalytic==1
replace subpopwhite = 1 if race4cat==1
gen subpopblack = 0   if subanalytic==1
replace subpopblack = 1 if race4cat==2
gen subpophisp = 0   if subanalytic==1
replace subpophisp = 1 if race4cat==3

gen agec = age - 15

keep if subanalytic==1

///suicide 
melogit suicide female i.race4cat c.agec##c.agec##c.agec , vce(cluster psuscid)  || aid: , pweight(schwt1)  
outreg2 using "racebywave.xls",  alpha(0.001, 0.01, 0.05) symbol(***, **,*)  dec(3) replace

melogit suicide female i.race4cat c.age##c.age##c.age, vce(cluster psuscid)  || aid: , pweight(schwt1)  
margins, at(race4cat=(1) age=(15(1)40)) at(race4cat=(2) age=(15(1)40)) at(race4cat=(3) age=(15(1)40))
marginsplot, noci graphregion(color(white)) title("Suicidal Ideation", color(black)) ///
plot1opts(lcolor("255 99 33") lwidth(medthick) mcolor("255 99 33") msymbol(none)) ///
plot2opts(lcolor("42 174 211") lwidth(medthick) mcolor("42 174 211") msymbol(none)) ///
plot3opts(lcolor("156 19 232") lwidth(medthick) mcolor("156 19 232") msymbol(none)) ///
legend(off) ///
ytitle(Probability) xtitle("") xlabel(none) ylabel(.04(.1).14)  
graph export race1.emf, replace


///binge
melogit binge female i.race4cat##c.agec##c.agec##c.agec , vce(cluster psuscid)  || aid: , pweight(schwt1)  
outreg2 using "racebywave.xls",  alpha(0.001, 0.01, 0.05) symbol(***, **,*)  dec(3) append

melogit binge female i.race4cat##c.age##c.age##c.age , vce(cluster psuscid)  || aid: , pweight(schwt1)  
margins, at(race4cat=(1) age=(15(1)40)) at(race4cat=(2) age=(15(1)40)) at(race4cat=(3) age=(15(1)40))
marginsplot, noci graphregion(color(white)) title("Heavy Drinking", color(black)) ///
plot1opts(lcolor("255 99 33") lwidth(medthick) mcolor("255 99 33") msymbol(none)) ///
plot2opts(lcolor("42 174 211") lwidth(medthick) mcolor("42 174 211") msymbol(none)) ///
plot3opts(lcolor("156 19 232") lwidth(medthick) mcolor("156 19 232") msymbol(none)) ///
legend(off) ///
ytitle(Probability) xtitle("Age") xlabel(none) ylabel(.1(.4).5)  
graph export race2.emf, replace


///marijuana 
melogit marijuana female i.race4cat##c.agec##c.agec##c.agec , vce(cluster psuscid)  || aid: , pweight(schwt1)  
outreg2 using "racebywave.xls",  alpha(0.001, 0.01, 0.05) symbol(***, **,*)  dec(3) append

melogit marijuana female i.race4cat##c.age##c.age##c.age , vce(cluster psuscid)  || aid: , pweight(schwt1)  
margins, at(race4cat=(1) age=(15(1)40)) at(race4cat=(2) age=(15(1)40)) at(race4cat=(3) age=(15(1)40))
marginsplot, noci graphregion(color(white)) title("Marijuana Use", color(black)) ///
plot1opts(lcolor("255 99 33") lwidth(medthick) mcolor("255 99 33") msymbol(none)) ///
plot2opts(lcolor("42 174 211") lwidth(medthick) mcolor("42 174 211") msymbol(none)) ///
plot3opts(lcolor("156 19 232") lwidth(medthick) mcolor("156 19 232") msymbol(none)) ///
legend(off) ytitle(Probability) xtitle("Age") ylabel(.1(.25).35)  
graph export race3.emf, replace

///depress
mepoisson depress female i.race4cat c.agec##c.agec##c.agec , vce(cluster psuscid)  || aid: , pweight(schwt1)  
outreg2 using "racebywave.xls",  alpha(0.001, 0.01, 0.05) symbol(***, **,*)  dec(3) append

mepoisson depress female i.race4cat c.age##c.age##c.age, vce(cluster psuscid)  || aid: , pweight(schwt1)  
margins, at(race4cat=(1) age=(15(1)40)) at(race4cat=(2) age=(15(1)40)) at(race4cat=(3) age=(15(1)40))
marginsplot, noci graphregion(color(white)) title("Depressive Symptoms", color(black)) ///
plot1opts(lcolor("255 99 33") lwidth(medthick) mcolor("255 99 33") msymbol(none)) ///
plot2opts(lcolor("42 174 211") lwidth(medthick) mcolor("42 174 211") msymbol(none)) ///
plot3opts(lcolor("156 19 232") lwidth(medthick) mcolor("156 19 232") msymbol(none)) ///
legend(off) ///
ytitle(Score) xtitle("") xlabel(none) ylabel(1.8(1.5)3.3)
graph export race4.emf, replace

