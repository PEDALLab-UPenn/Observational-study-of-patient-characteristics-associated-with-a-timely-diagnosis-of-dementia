*************************************************************************************************
* Do file to create analytic file(s) for Factors Associated with Timely Dementia Diagnosis study
*************************************************************************************************

** Open the original Langa-Weir data file and save a copy
use "X\cognfinalimp_9514wide.dta", clear
save "X\LangaWeirSmall.dta", replace

** Keep only needed variables
keep hhid pn cogtot27_imp* cogfunction* prxyscore_imp*

** Sort, save, and close for later merging
sort hhid pn 
save "X\LangaWeirSmall.dta", replace
clear

** Open the original cross-wave cognitive imputations file and save a copy
use "X\COGIMP9216A_R.dta", clear
save "X\CogImpSmall.dta", replace

** Keep only needed variables
keep HHID PN R12STATUS R12IMRC R12DLRC R12SER7 R12BWC20 R12FIMRC R12FDLRC R12FSER7 R12FBWC20 ///
R13STATUS R13IMRC R13DLRC R13SER7 R13BWC20 R13FIMRC R13FDLRC R13FSER7 R13FBWC20

** Sort, save, and close for later merging
rename HHID hhid
rename PN pn
sort hhid pn
save "X\CogImpSmall.dta", replace
clear

** Grab all necessary variables from the RAND dataset to calculate the cognitive scores
use hhidpn hhid pn ragender rabmonth rabyear inw* r*proxy hacohort racohbyr raracem rahispan raeduc ravetrn r*iwendm r*iwendy r*mstat ///
radmonth radyear r*dlrc r2adlr10 r*fdlrc r*imrc r2aimr10 r*fimrc r*ser7 r*fser7 r*bwc20 r*fbwc20 r*agey_e r*iadlza r*adla r*shlt ///
using "X\randhrs1992_2016v1.dta", clear

** Sort and save
sort hhid pn
save "X\TimelyDxFullData.dta", replace

** Merge with the cognitive imputations and the Langa-Weir data files
merge 1:1 hhid pn using "X\CogImpSmall.dta", gen(mergeCogImp)
sort hhid pn
merge 1:1 hhid pn using "X\LangaWeirSmall.dta", gen(mergeLangaWeir)

** Sort and save data file 
sort hhidpn
save "X\TimelyDxFullData.dta", replace

** Merge all of the extra core variables onto the dataset (proxy iw cognitive impairment rating, proxy memory rating)
merge 1:1 hhidpn using "X\ExtraCoreVariables95.dta", gen(merge95)
merge 1:1 hhidpn using "X\ExtraCoreVariables96.dta", gen(merge96)
merge 1:1 hhidpn using "X\ExtraCoreVariables98.dta", gen(merge98)
merge 1:1 hhidpn using "X\ExtraCoreVariables00.dta", gen(merge00)
merge 1:1 hhidpn using "X\ExtraCoreVariables02.dta", gen(merge02)
merge 1:1 hhidpn using "X\ExtraCoreVariables04.dta", gen(merge04)
merge 1:1 hhidpn using "X\ExtraCoreVariables06.dta", gen(merge06)
merge 1:1 hhidpn using "X\ExtraCoreVariables08.dta", gen(merge08)
merge 1:1 hhidpn using "X\ExtraCoreVariables10.dta", gen(merge10)
merge 1:1 hhidpn using "X\ExtraCoreVariables12.dta", gen(merge12)
merge 1:1 hhidpn using "X\ExtraCoreVariables14.dta", gen(merge14)
merge 1:1 hhidpn using "X\ExtraCoreVariables16.dta", gen(merge16)
drop merge*

save "X\TimelyDxFullData.dta", replace

** Calculate cognitive scale scores for each wave from 3-13 (1995-2016)
** First fill with scores if self-respondent
rename R13IMRC r13imrc
rename R13DLRC r13dlrc
rename R13SER7 r13ser7
rename R13BWC20 r13bwc20

forvalues wave=3/13 {
  gen cogscale`wave'=.
  replace cogscale`wave'=r`wave'dlrc+r`wave'imrc+r`wave'ser7+r`wave'bwc20
}

save "X\TimelyDxFullData.dta", replace

** Next, fill with scores if proxy completed interview
** First, need to clean up the variables that were not included in RAND dataset so consistently coded
** Proxy assessment of respondent's memory
gen pcratememory3=d1056
replace pcratememory3=e1056 if missing(d1056)
recode pcratememory3 (1=0) (2=1) (3=2) (4=3) (5=4) (else=.)

gen pcratememory4=f1373
recode pcratememory4 (1=0) (2=1) (3=2) (4=3) (5=4) (else=.)

gen pcratememory5=g1527
recode pcratememory5 (1=0) (2=1) (3=2) (4=3) (5=4) (else=.)

gen pcratememory6=hd501
recode pcratememory6 (1=0) (2=1) (3=2) (4=3) (5=4) (else=.)

gen pcratememory7=jd501
recode pcratememory7 (1=0) (2=1) (3=2) (4=3) (5=4) (else=.)

gen pcratememory8=kd501
recode pcratememory8 (1=0) (2=1) (3=2) (4=3) (5=4) (else=.)

gen pcratememory9=ld501
recode pcratememory9 (1=0) (2=1) (3=2) (4=3) (5=4) (else=.)

gen pcratememory10=md501
recode pcratememory10 (1=0) (2=1) (3=2) (4=3) (5=4) (else=.)

gen pcratememory11=nd501
recode pcratememory11 (1=0) (2=1) (3=2) (4=3) (5=4) (else=.)

gen pcratememory12=od501
recode pcratememory12 (1=0) (2=1) (3=2) (4=3) (5=4) (else=.)

gen pcratememory13=pd501
recode pcratememory13 (1=0) (2=1) (3=2) (4=3) (5=4) (else=.)

** Interviewer's assessment of difficulty completing interview
gen diffcompint5=g517
recode diffcompint5 (1=0) (2=1) (3/4=2) (else=.)

gen diffcompint6=ha011
recode diffcompint6 (1=0) (2=1) (3=2) (else=.)

gen diffcompint7=ja011
recode diffcompint7 (1=0) (2=1) (3=2) (else=.)

gen diffcompint8=ka011
recode diffcompint8 (1=0) (2=1) (3=2) (else=.)

gen diffcompint9=la011
recode diffcompint9 (1=0) (2=1) (3=2) (else=.)

gen diffcompint10=ma011
recode diffcompint10 (1=0) (2=1) (3=2) (else=.)

gen diffcompint11=na011
recode diffcompint11 (1=0) (2=1) (3=2) (else=.)

gen diffcompint12=oa011
recode diffcompint12 (1=0) (2=1) (3=2) (else=.)

gen diffcompint13=pa011
recode diffcompint13 (1=0) (2=1) (3=2) (else=.)

** Now fill with scores if proxy respondent
forvalues wave=3/4 {
  replace cogscale`wave'=pcratememory`wave'+r`wave'iadlza if (r`wave'proxy==1 & cogscale`wave'==.)
}

forvalues wave=5/13 {
  replace cogscale`wave'=pcratememory`wave'+r`wave'iadlza+diffcompint`wave' if (r`wave'proxy==1 & cogscale`wave'==.)
}

save "X\TimelyDxFullData.dta", replace

** Create a dementia indicator for every wave (3-13)
forvalues wave=3/4 {
  gen dementiawave`wave'=.
  replace dementiawave`wave'=1 if ((cogscale`wave'>=0 & cogscale`wave'<=6) & r`wave'proxy==0)
  replace dementiawave`wave'=0 if ((cogscale`wave'>=7 & cogscale`wave'<=27) & r`wave'proxy==0)
  replace dementiawave`wave'=1 if ((cogscale`wave'>=5 & cogscale`wave'<=9) & r`wave'proxy==1)
  replace dementiawave`wave'=0 if ((cogscale`wave'>=0 & cogscale`wave'<=4) & r`wave'proxy==1)
}

forvalues wave=5/13 {
  gen dementiawave`wave'=.
  replace dementiawave`wave'=1 if ((cogscale`wave'>=0 & cogscale`wave'<=6) & r`wave'proxy==0)
  replace dementiawave`wave'=0 if ((cogscale`wave'>=7 & cogscale`wave'<=27) & r`wave'proxy==0)
  replace dementiawave`wave'=1 if ((cogscale`wave'>=6 & cogscale`wave'<=11) & r`wave'proxy==1)
  replace dementiawave`wave'=0 if ((cogscale`wave'>=0 & cogscale`wave'<=5) & r`wave'proxy==1)
}

** Now create a summary dementia indicator
gen dementiadx=(dementiawave3==1 | dementiawave4==1 | dementiawave5==1 | dementiawave6==1 | dementiawave7==1 | dementiawave8==1 | dementiawave9==1 | dementiawave10==1 | dementiawave11==1 | dementiawave12==1 | dementiawave13==1)

save "X\TimelyDxFullData.dta", replace

** Identify the wave of the first positive score
gen firstpositive=.
replace firstpositive=3 if dementiawave3==1
replace firstpositive=4 if (firstpositive==. & dementiawave4==1)
replace firstpositive=5 if (firstpositive==. & dementiawave5==1)
replace firstpositive=6 if (firstpositive==. & dementiawave6==1)
replace firstpositive=7 if (firstpositive==. & dementiawave7==1)
replace firstpositive=8 if (firstpositive==. & dementiawave8==1)
replace firstpositive=9 if (firstpositive==. & dementiawave9==1)
replace firstpositive=10 if (firstpositive==. & dementiawave10==1)
replace firstpositive=11 if (firstpositive==. & dementiawave11==1)
replace firstpositive=12 if (firstpositive==. & dementiawave12==1)
replace firstpositive=13 if (firstpositive==. & dementiawave13==1)

** Calculate the date for the first positive score
gen firstpositivedate=mdy(r3iwendm,15,r3iwendy) if firstpositive==3
format firstpositivedate %td

forvalues wave=4/13 {
  replace firstpositivedate=mdy(r`wave'iwendm,15,r`wave'iwendy) if firstpositive==`wave'
}

** Did the respondent have a valid score in the wave prior to the first positive wave (did they go from a valid
** negative dementia score to a positive dementia score)?
gen validpriorwave=0
replace validpriorwave=1 if (firstpositive==4 & inw3==1 & !missing(cogscale3))
replace validpriorwave=1 if (firstpositive==5 & inw4==1 & !missing(cogscale4))
replace validpriorwave=1 if (firstpositive==6 & inw5==1 & !missing(cogscale5))
replace validpriorwave=1 if (firstpositive==7 & inw6==1 & !missing(cogscale6))
replace validpriorwave=1 if (firstpositive==8 & inw7==1 & !missing(cogscale7))
replace validpriorwave=1 if (firstpositive==9 & inw8==1 & !missing(cogscale8))
replace validpriorwave=1 if (firstpositive==10 & inw9==1 & !missing(cogscale9))
replace validpriorwave=1 if (firstpositive==11 & inw10==1 & !missing(cogscale10))
replace validpriorwave=1 if (firstpositive==12 & inw11==1 & !missing(cogscale11))
replace validpriorwave=1 if (firstpositive==13 & inw12==1 & !missing(cogscale12))

save "X\TimelyDxFullData.dta", replace

** Create a CIND indicator for every wave (3-13) 
forvalues wave=3/4 {
  gen cindwave`wave'=.
  replace cindwave`wave'=1 if ((cogscale`wave'>=7 & cogscale`wave'<=11) & r`wave'proxy==0)
  replace cindwave`wave'=0 if ((cogscale`wave'>=0 & cogscale`wave'<=6) & r`wave'proxy==0)
  replace cindwave`wave'=0 if ((cogscale`wave'>=12 & cogscale`wave'<=27) & r`wave'proxy==0)
  replace cindwave`wave'=1 if ((cogscale`wave'>=3 & cogscale`wave'<=4) & r`wave'proxy==1)
  replace cindwave`wave'=0 if ((cogscale`wave'>=0 & cogscale`wave'<=2) & r`wave'proxy==1)
  replace cindwave`wave'=0 if ((cogscale`wave'>=5 & cogscale`wave'<=9) & r`wave'proxy==1)
}

forvalues wave=5/13 {
  gen cindwave`wave'=.
  replace cindwave`wave'=1 if ((cogscale`wave'>=7 & cogscale`wave'<=11) & r`wave'proxy==0)
  replace cindwave`wave'=0 if ((cogscale`wave'>=0 & cogscale`wave'<=6) & r`wave'proxy==0)
  replace cindwave`wave'=0 if ((cogscale`wave'>=12 & cogscale`wave'<=27) & r`wave'proxy==0)
  replace cindwave`wave'=1 if ((cogscale`wave'>=3 & cogscale`wave'<=5) & r`wave'proxy==1)
  replace cindwave`wave'=0 if ((cogscale`wave'>=0 & cogscale`wave'<=2) & r`wave'proxy==1)
  replace cindwave`wave'=0 if ((cogscale`wave'>=6 & cogscale`wave'<=11) & r`wave'proxy==1)
}

** Now create a summary CIND indicator
gen cinddx=(cindwave3==1 | cindwave4==1 | cindwave5==1 | cindwave6==1 | cindwave7==1 | cindwave8==1 | cindwave9==1 | cindwave10==1 | cindwave11==1 | cindwave12==1 | cindwave13==1)

save "X\TimelyDxFullData.dta", replace

** Identify the wave person first qualified as CIND
gen firstwavecind=.
replace firstwavecind=3 if cindwave3==1
replace firstwavecind=4 if (firstwavecind==. & cindwave4==1)
replace firstwavecind=5 if (firstwavecind==. & cindwave5==1)
replace firstwavecind=6 if (firstwavecind==. & cindwave6==1)
replace firstwavecind=7 if (firstwavecind==. & cindwave7==1)
replace firstwavecind=8 if (firstwavecind==. & cindwave8==1)
replace firstwavecind=9 if (firstwavecind==. & cindwave9==1)
replace firstwavecind=10 if (firstwavecind==. & cindwave10==1)
replace firstwavecind=11 if (firstwavecind==. & cindwave11==1)
replace firstwavecind=12 if (firstwavecind==. & cindwave12==1)
replace firstwavecind=13 if (firstwavecind==. & cindwave13==1)

** Calculate the date for the first time qualified as CIND
gen firstcinddate=mdy(r3iwendm,15,r3iwendy) if firstwavecind==3
format firstcinddate %td

forvalues wave=4/13 {
  replace firstcinddate=mdy(r`wave'iwendm,15,r`wave'iwendy) if firstwavecind==`wave'
}

** Create a normal cognition indicator for every wave (3-13)
forvalues wave=3/4 {
  gen normalwave`wave'=.
  replace normalwave`wave'=1 if ((cogscale`wave'>=12 & cogscale`wave'<=27) & r`wave'proxy==0)
  replace normalwave`wave'=0 if ((cogscale`wave'>=0 & cogscale`wave'<=11) & r`wave'proxy==0)
  replace normalwave`wave'=1 if ((cogscale`wave'>=0 & cogscale`wave'<=2) & r`wave'proxy==1)
  replace normalwave`wave'=0 if ((cogscale`wave'>=3 & cogscale`wave'<=9) & r`wave'proxy==1)
}

forvalues wave=5/13 {
  gen normalwave`wave'=.
  replace normalwave`wave'=1 if ((cogscale`wave'>=12 & cogscale`wave'<=27) & r`wave'proxy==0)
  replace normalwave`wave'=0 if ((cogscale`wave'>=0 & cogscale`wave'<=11) & r`wave'proxy==0)
  replace normalwave`wave'=1 if ((cogscale`wave'>=0 & cogscale`wave'<=2) & r`wave'proxy==1)
  replace normalwave`wave'=0 if ((cogscale`wave'>=3 & cogscale`wave'<=11) & r`wave'proxy==1)
}

** Did the respondent have a normal cognition score in the wave immediately prior to the first qualifying CIND score
gen normalpriorwave=0
replace normalpriorwave=1 if (firstwavecind==4 & inw3==1 & normalwave3==1)
replace normalpriorwave=1 if (firstwavecind==5 & inw4==1 & normalwave4==1)
replace normalpriorwave=1 if (firstwavecind==6 & inw5==1 & normalwave5==1)
replace normalpriorwave=1 if (firstwavecind==7 & inw6==1 & normalwave6==1)
replace normalpriorwave=1 if (firstwavecind==8 & inw7==1 & normalwave7==1)
replace normalpriorwave=1 if (firstwavecind==9 & inw8==1 & normalwave8==1)
replace normalpriorwave=1 if (firstwavecind==10 & inw9==1 & normalwave9==1)
replace normalpriorwave=1 if (firstwavecind==11 & inw10==1 & normalwave10==1)
replace normalpriorwave=1 if (firstwavecind==12 & inw11==1 & normalwave11==1)
replace normalpriorwave=1 if (firstwavecind==13 & inw12==1 & normalwave12==1)

save "X\TimelyDxFullData.dta", replace

** Now, run some QC on the calculated scores and dementia and CIND determination by bouncing it off of the Langa-Weir categorizations
gen cogfunction9596=cogfunction1995
replace cogfunction9596=cogfunction1996 if cogfunction9596==.

tab dementiawave3 cogfunction9596 if inw3==1, missing
tab cindwave3 cogfunction9596 if inw3==1, missing
tab normalwave3 cogfunction9596 if inw3==1, missing

tab dementiawave4 cogfunction1998 if inw4==1, missing
tab cindwave4 cogfunction1998 if inw4==1, missing
tab normalwave4 cogfunction1998 if inw4==1, missing

tab dementiawave5 cogfunction2000 if inw5==1, missing
tab cindwave5 cogfunction2000 if inw5==1, missing
tab normalwave5 cogfunction2000 if inw5==1, missing

tab dementiawave6 cogfunction2002 if inw6==1, missing
tab cindwave6 cogfunction2002 if inw6==1, missing
tab normalwave6 cogfunction2002 if inw6==1, missing

tab dementiawave7 cogfunction2004 if inw7==1, missing
tab cindwave7 cogfunction2004 if inw7==1, missing
tab normalwave7 cogfunction2004 if inw7==1, missing

tab dementiawave8 cogfunction2006 if inw8==1, missing
tab cindwave8 cogfunction2006 if inw8==1, missing
tab normalwave8 cogfunction2006 if inw8==1, missing

tab dementiawave9 cogfunction2008 if inw9==1, missing
tab cindwave9 cogfunction2008 if inw9==1, missing
tab normalwave9 cogfunction2008 if inw9==1, missing

tab dementiawave10 cogfunction2010 if inw10==1, missing
tab cindwave10 cogfunction2010 if inw10==1, missing
tab normalwave10 cogfunction2010 if inw10==1, missing

tab dementiawave11 cogfunction2012 if inw11==1, missing
tab cindwave11 cogfunction2012 if inw11==1, missing
tab normalwave11 cogfunction2012 if inw11==1, missing

tab dementiawave12 cogfunction2014 if inw12==1, missing
tab cindwave12 cogfunction2014 if inw12==1, missing
tab normalwave12 cogfunction2014 if inw12==1, missing

save "X\TimelyDxFullData.dta", replace
clear

** Grab outcome variables and covariates from the RAND dataset
use hhidpn r*wtresp r*hibpe r*diabe r*cancre r*lunge r*hearte r*stroke r*psyche r*arthre r*conde ///
r*govmr r*govmd r*govva r*covr r*covs r*henum r*hiothp ///
r*hosp r*nrshom r*doctor r*doctim r*shlt r*memry r*memrye r*alzhe r*alzhee r*demen r*demene h*hhres ///
using "X\randhrs1992_2016v1.dta", clear

** Sort and save data file 
sort hhidpn
save "X\ExtraVariables.dta", replace
clear

** Merge on to data file with case identifiers
use "X\TimelyDxFullData.dta", clear
sort hhidpn 
merge 1:1 hhidpn using "X\ExtraVariables.dta", gen(mergeCovariates)

** Create summary eligibility variables (one for dementia analysis, one for CIND analysis)
gen eligibledementia=(dementiadx==1 & validpriorwave==1)
gen eligiblecind=(cinddx==1 & normalpriorwave==1)

save "X\TimelyDxFullData.dta", replace

** Create the outcome variable using has a doctor ever told you 
** First, create a summary variable for each wave - has a doctor ever told you that you have a memory problem, alzheimer's, or dementia
gen docdxmemory4=r4memrye==1
gen docdxmemory5=docdxmemory4==1 | r5memrye==1
gen docdxmemory6=docdxmemory5==1 | r6memrye==1
gen docdxmemory7=docdxmemory6==1 | r7memrye==1
gen docdxmemory8=docdxmemory7==1 | r8memrye==1
gen docdxmemory9=docdxmemory8==1 | r9memrye==1
gen docdxmemory10=r10alzhee==1 | r10demene==1 | docdxmemory9==1 
gen docdxmemory11=r11alzhee==1 | r11demene==1 | docdxmemory10==1 
gen docdxmemory12=r12alzhee==1 | r12demene==1 | docdxmemory11==1 
gen docdxmemory13=r13alzhee==1 | r13demene==1 | docdxmemory12==1

** Create the concurrent wave dx - Doctor has told a person they have a memory issue in a prior or current wave to their first dementia 
** qualifying score or first CIND qualifying score
gen concurrentdementiadx=0
forvalues wave=4/13 {
  replace concurrentdementiadx=1 if (firstpositive==`wave' & docdxmemory`wave'==1)
}

gen concurrentcinddx=0
forvalues wave=4/9 {
  replace concurrentcinddx=1 if (firstwavecind==`wave' & docdxmemory`wave'==1)
}

save "X\TimelyDxFullData.dta", replace

** Save a copy of the dataset and keep only the eligible participants for the dementia analysis
save "X\EligibleDementiaPeeps.dta", replace

keep if eligibledementia==1
tab firstpositive
drop if firstpositive==3
save "X\EligibleDementiaPeeps.dta", replace

** Calculate covariates (as of the time of the first positive wave)
** Was the first positive wave done by proxy or self
gen firstpositiveproxy=.
forvalues wave=4/13 {
  replace firstpositiveproxy=r`wave'proxy if firstpositive==`wave'
}

** Sociodemographic characteristics
** Age
gen agedementiadx=.
forvalues wave=4/13 {
  replace agedementiadx=r`wave'agey_e if firstpositive==`wave'
}

** Sex
gen male=ragender==1

** Race/ethnicity
gen race=.
replace race=1 if (raracem==1 & rahispan==0)
replace race=2 if (raracem==2 & rahispan==0)
replace race=3 if rahispan==1
replace race=4 if (raracem==3 & rahispan==0)
label define racelabel 1 "non-hispanic white" 2 "non-hispanic black" 3 "hispanic" 4 "non-hispanic other"
label values race racelabel

gen black=race==2
gen hispanic=race==3
gen otherrace=race==4

** Education
gen education=raeduc
recode education (3=2) (4=3) (5=4)
label define educationlabel 1 "less than high school" 2 "high school graduate or GED" 3 "some college" 4 "college and above"
label values education educationlabel

gen lesshsgrad=education==1
gen hsgrad=education==2
gen somecollege=education==3
gen collegegrad=education==4

** Marital status
gen marital=.
forvalues wave=4/13 {
  replace marital=r`wave'mstat if firstpositive==`wave'
}

replace marital=5 if hhidpn==200196010
recode marital (1/3=1) (4/6=2) (7=3) (8=4)
label define maritallabel 1 "married/partnered" 2 "separated/divorced" 3 "widowed" 4 "never married"
label values marital maritallabel

gen divorced=marital==2
gen widowed=marital==3
gen nevermarried=marital==4

** Living alone
gen numinhouse=.
forvalues wave=4/13 {
  replace numinhouse=h`wave'hhres if firstpositive==`wave'
}

gen livealone=numinhouse==1

** Health characteristics
** Self-rated health
gen selfhealth=.
forvalues wave=4/13 {
  replace selfhealth=r`wave'shlt if firstpositive==`wave'
}

recode selfhealth (.d=9) (.r=9)
label define selfhealthlabel 1 "excellent" 2 "very good" 3 "good" 4 "fair" 5 "poor" 9 "unknown"
label values selfhealth selfhealthlabel

gen goodselfhealth=selfhealth<=3
gen poorselfhealth=selfhealth==4 | selfhealth==5

** Number of conditions diagnosed by doctor
gen numconditions=.
forvalues wave=4/13 {
  replace numconditions=r`wave'conde if firstpositive==`wave'
}

** Health care utilization
** Any hospital stay during last 2 years/since last wave
gen anyhosp=.
forvalues wave=4/13 {
  replace anyhosp=r`wave'hosp if firstpositive==`wave'
}

recode anyhosp (.d=0) (.m=0)

** Any nursing home stay during last 2 years/since last wave
gen anynh=.
forvalues wave=4/13 {
  replace anynh=r`wave'nrshom if firstpositive==`wave'
}

recode anynh (.d=0) (.m=0)

** Any doctor's visit during last 2 years/since last wave
gen anydoctor=.
forvalues wave=4/13 {
  replace anydoctor=r`wave'doctor if firstpositive==`wave'
}

recode anydoctor (.d=0) (.m=0)

** Medicaid insurance coverage
gen medicaid=.
forvalues wave=4/13 {
  replace medicaid=r`wave'govmd if firstpositive==`wave'
}

recode medicaid (.d=0) (.m=0) (.r=0)

** Medicare insurance coverage
gen medicare=.
forvalues wave=4/13 {
  replace medicare=r`wave'govmr if firstpositive==`wave'
}

recode medicare (.d=0) (.m=0) (.r=0)

** VA/Champus insurance coverage
gen vachampus=.
forvalues wave=4/13 {
  replace vachampus=r`wave'govva if firstpositive==`wave'
}

recode vachampus (.d=0) (.m=0) (.r=0)

** Employer-sponsored coverage (either respondent or spouse's employer)
gen respempins=.
forvalues wave=4/13 {
  replace respempins=r`wave'covr if firstpositive==`wave'
}

recode respempins (.c=1) (.e=1) (.d=0) (.m=0) (.r=0)

gen spouseempins=.
forvalues wave=4/13 {
  replace spouseempins=r`wave'covs if firstpositive==`wave'
}

recode spouseempins (.c=1) (.e=1) (.d=0) (.m=0) (.r=0)

gen employerins=respempins==1 | spouseempins==1

** Create a variable with the year of the first positive score
gen firstpositiveyear=.
forvalues wave=4/13 {
  replace firstpositiveyear=r`wave'iwendy if firstpositive==`wave'
}

save "X\EligibleDementiaPeeps.dta", replace
clear

** Open the full dataset and keep only the eligible participants for the CIND analysis 
** NOTE: This was the definition of the CIND cohort that was used for the initial article submission. An updated definition for the CIND cohort was used 
** for the final publication. The code for that is provided below.

use "X\TimelyDxFullData.dta", clear
save "X\eligiblecindpeeps.dta", replace

keep if eligiblecind==1
tab firstwavecind
drop if firstwavecind==3 | firstwavecind==10 | firstwavecind==11 | firstwavecind==12 | firstwavecind==13
save "X\eligiblecindpeeps.dta", replace

** Calculate covariates (as of the time of the first positive wave)
** Was the first positive wave done by proxy or self
gen firstpositiveproxy=.
forvalues wave=4/9 {
  replace firstpositiveproxy=r`wave'proxy if firstwavecind==`wave'
}

** Sociodemographic characteristics
** Age
gen agecinddx=.
forvalues wave=4/9 {
  replace agecinddx=r`wave'agey_e if firstwavecind==`wave'
}

** Sex
gen male=ragender==1

** Race/ethnicity
gen race=.
replace race=1 if (raracem==1 & rahispan==0)
replace race=2 if (raracem==2 & rahispan==0)
replace race=3 if rahispan==1
replace race=4 if (raracem==3 & rahispan==0)
label define racelabel 1 "non-hispanic white" 2 "non-hispanic black" 3 "hispanic" 4 "non-hispanic other"
label values race racelabel

gen black=race==2
gen hispanic=race==3
gen otherrace=race==4

** Education
gen education=raeduc
recode education (3=2) (4=3) (5=4)
label define educationlabel 1 "less than high school" 2 "high school graduate or GED" 3 "some college" 4 "college and above"
label values education educationlabel

gen lesshsgrad=education==1
gen hsgrad=education==2
gen somecollege=education==3
gen collegegrad=education==4

** Marital status
gen marital=.
forvalues wave=4/9 {
  replace marital=r`wave'mstat if firstwavecind==`wave'
}

replace marital=5 if hhidpn==200196010
recode marital (1/3=1) (4/6=2) (7=3) (8=4)
label define maritallabel 1 "married/partnered" 2 "separated/divorced" 3 "widowed" 4 "never married"
label values marital maritallabel

gen divorced=marital==2
gen widowed=marital==3
gen nevermarried=marital==4

** Living alone
gen numinhouse=.
forvalues wave=4/9 {
  replace numinhouse=h`wave'hhres if firstwavecind==`wave'
}

gen livealone=numinhouse==1

** Health characteristics
** Self-rated health
gen selfhealth=.
forvalues wave=4/9 {
  replace selfhealth=r`wave'shlt if firstwavecind==`wave'
}

recode selfhealth (.d=9) (.r=9)
label define selfhealthlabel 1 "excellent" 2 "very good" 3 "good" 4 "fair" 5 "poor" 9 "unknown"
label values selfhealth selfhealthlabel

gen goodselfhealth=selfhealth<=3
gen poorselfhealth=selfhealth==4 | selfhealth==5

** Number of conditions diagnosed by doctor
gen numconditions=.
forvalues wave=4/9 {
  replace numconditions=r`wave'conde if firstwavecind==`wave'
}

** Health care utilization
** Any hospital stay during last 2 years/since last wave
gen anyhosp=.
forvalues wave=4/9 {
  replace anyhosp=r`wave'hosp if firstwavecind==`wave'
}

recode anyhosp (.d=0) (.m=0)

** Any nursing home stay during last 2 years/since last wave
gen anynh=.
forvalues wave=4/9 {
  replace anynh=r`wave'nrshom if firstwavecind==`wave'
}

recode anynh (.d=0) (.m=0)

** Any doctor's visit during last 2 years/since last wave
gen anydoctor=.
forvalues wave=4/9 {
  replace anydoctor=r`wave'doctor if firstwavecind==`wave'
}

recode anydoctor (.d=0) (.m=0)

** Medicaid insurance coverage
gen medicaid=.
forvalues wave=4/9 {
  replace medicaid=r`wave'govmd if firstwavecind==`wave'
}

recode medicaid (.d=0) (.m=0) (.r=0)

** Medicare insurance coverage
gen medicare=.
forvalues wave=4/9 {
  replace medicare=r`wave'govmr if firstwavecind==`wave'
}

recode medicare (.d=0) (.m=0) (.r=0)

** VA/Champus insurance coverage
gen vachampus=.
forvalues wave=4/9 {
  replace vachampus=r`wave'govva if firstwavecind==`wave'
}

recode vachampus (.d=0) (.m=0) (.r=0)

** Employer-sponsored coverage (either respondent or spouse's employer)
gen respempins=.
forvalues wave=4/9 {
  replace respempins=r`wave'covr if firstwavecind==`wave'
}

recode respempins (.c=1) (.e=1) (.d=0) (.m=0) (.r=0)

gen spouseempins=.
forvalues wave=4/9 {
  replace spouseempins=r`wave'covs if firstwavecind==`wave'
}

recode spouseempins (.c=1) (.e=1) (.d=0) (.m=0) (.r=0)

gen employerins=respempins==1 | spouseempins==1

** Create a variable with the year of the first positive score
gen firstpositiveyear=.
forvalues wave=4/9 {
  replace firstpositiveyear=r`wave'iwendy if firstwavecind==`wave'
}

save "X\eligiblecindpeeps.dta", replace
clear


******** Alternate definition for the incident CIND cohort ***********
** Open the dataset with all needed variables
use "X\TimelyDxFullData.dta", clear

** Did the respondent have a CIND-qualifying score in the wave immediately after the first qualifying CIND score
gen cindsubsequentwave=0
replace cindsubsequentwave=1 if (firstwavecind==3 & inw4==1 & (cindwave4==1 | dementiawave4==1))
replace cindsubsequentwave=1 if (firstwavecind==4 & inw5==1 & (cindwave5==1 | dementiawave5==1))
replace cindsubsequentwave=1 if (firstwavecind==5 & inw6==1 & (cindwave6==1 | dementiawave6==1))
replace cindsubsequentwave=1 if (firstwavecind==6 & inw7==1 & (cindwave7==1 | dementiawave7==1))
replace cindsubsequentwave=1 if (firstwavecind==7 & inw8==1 & (cindwave8==1 | dementiawave8==1))
replace cindsubsequentwave=1 if (firstwavecind==8 & inw9==1 & (cindwave9==1 | dementiawave9==1))
replace cindsubsequentwave=1 if (firstwavecind==9 & inw10==1 & (cindwave10==1 | dementiawave10==1))
replace cindsubsequentwave=1 if (firstwavecind==10 & inw11==1 & (cindwave11==1 | dementiawave11==1))
replace cindsubsequentwave=1 if (firstwavecind==11 & inw12==1 & (cindwave12==1 | dementiawave12==1))
replace cindsubsequentwave=1 if (firstwavecind==12 & inw13==1 & (cindwave13==1 | dementiawave13==1))

** Create a new summary eligibility variable for the CINDx2 cohort
gen eligiblecind2dx=(cinddx==1 & normalpriorwave==1 & cindsubsequentwave==1)

save "X\TimelyDxFullData.dta", replace

** Create an updated concurrent wave dx - Doctor has told a person they have a memory issue in the wave prior to, concurrent to, or subsequent to the first CIND qualifying score
gen concurrentcinddx2dx=0
replace concurrentcinddx2dx=1 if (firstwavecind==4 & (docdxmemory4==1 | docdxmemory5==1))
replace concurrentcinddx2dx=1 if (firstwavecind==5 & (docdxmemory5==1 | docdxmemory6==1))
replace concurrentcinddx2dx=1 if (firstwavecind==6 & (docdxmemory6==1 | docdxmemory7==1))
replace concurrentcinddx2dx=1 if (firstwavecind==7 & (docdxmemory7==1 | docdxmemory8==1))
replace concurrentcinddx2dx=1 if (firstwavecind==8 & (docdxmemory8==1 | docdxmemory9==1))

save "X\TimelyDxFullData.dta", replace

** Keep only the eligible participants for the CINDx2 analysis
save "X\eligiblecind2dxpeeps.dta", replace

keep if eligiblecind2dx==1
tab firstwavecind
drop if firstwavecind==3 | firstwavecind==9 | firstwavecind==10 | firstwavecind==11 | firstwavecind==12 | firstwavecind==13
save "X\eligiblecind2dxpeeps.dta", replace

** Calculate covariates (as of the time of the first positive wave)
** Was the first positive wave done by proxy or self
gen firstpositiveproxy=.
forvalues wave=4/8 {
  replace firstpositiveproxy=r`wave'proxy if firstwavecind==`wave'
}

** Sociodemographic characteristics
** Age
gen agecinddx=.
forvalues wave=4/8 {
  replace agecinddx=r`wave'agey_e if firstwavecind==`wave'
}

** Sex
gen male=ragender==1

** Race/ethnicity
gen race=.
replace race=1 if (raracem==1 & rahispan==0)
replace race=2 if (raracem==2 & rahispan==0)
replace race=3 if rahispan==1
replace race=4 if (raracem==3 & rahispan==0)
label define racelabel 1 "non-hispanic white" 2 "non-hispanic black" 3 "hispanic" 4 "non-hispanic other"
label values race racelabel

gen black=race==2
gen hispanic=race==3
gen otherrace=race==4

** Education
gen education=raeduc
recode education (3=2) (4=3) (5=4)
label define educationlabel 1 "less than high school" 2 "high school graduate or GED" 3 "some college" 4 "college and above"
label values education educationlabel

gen lesshsgrad=education==1
gen hsgrad=education==2
gen somecollege=education==3
gen collegegrad=education==4

** Marital status
gen marital=.
forvalues wave=4/8 {
  replace marital=r`wave'mstat if firstwavecind==`wave'
}

replace marital=5 if hhidpn==200196010
recode marital (1/3=1) (4/6=2) (7=3) (8=4)
label define maritallabel 1 "married/partnered" 2 "separated/divorced" 3 "widowed" 4 "never married"
label values marital maritallabel

gen divorced=marital==2
gen widowed=marital==3
gen nevermarried=marital==4

** Living alone
gen numinhouse=.
forvalues wave=4/8 {
  replace numinhouse=h`wave'hhres if firstwavecind==`wave'
}

gen livealone=numinhouse==1

** Health characteristics
** Self-rated health
gen selfhealth=.
forvalues wave=4/8 {
  replace selfhealth=r`wave'shlt if firstwavecind==`wave'
}

recode selfhealth (.d=9) (.r=9)
label define selfhealthlabel 1 "excellent" 2 "very good" 3 "good" 4 "fair" 5 "poor" 9 "unknown"
label values selfhealth selfhealthlabel

gen goodselfhealth=selfhealth<=3
gen poorselfhealth=selfhealth==4 | selfhealth==5

** Number of conditions diagnosed by doctor
gen numconditions=.
forvalues wave=4/8 {
  replace numconditions=r`wave'conde if firstwavecind==`wave'
}

** Health care utilization
** Any hospital stay during the 2 years prior to first wave OR the 2 years prior to subsequent wave
gen anyhospfirstwave=.
forvalues wave=4/8 {
  replace anyhospfirstwave=r`wave'hosp if firstwavecind==`wave'
}

recode anyhospfirstwave (.d=0) (.m=0) (.r=0)

gen anyhospsubwave=.
replace anyhospsubwave=r5hosp if firstwavecind==4
replace anyhospsubwave=r6hosp if firstwavecind==5
replace anyhospsubwave=r7hosp if firstwavecind==6
replace anyhospsubwave=r8hosp if firstwavecind==7
replace anyhospsubwave=r9hosp if firstwavecind==8

recode anyhospsubwave (.d=0) (.m=0) (.r=0)

gen anyhosp=anyhospfirstwave==1 | anyhospsubwave==1

** Any nursing home stay during last 2 years/since last wave
gen anynhfirstwave=.
forvalues wave=4/8 {
  replace anynhfirstwave=r`wave'nrshom if firstwavecind==`wave'
}

recode anynhfirstwave (.d=0) (.m=0) (.r=0)

gen anynhsubwave=.
replace anynhsubwave=r5nrshom if firstwavecind==4
replace anynhsubwave=r6nrshom if firstwavecind==5
replace anynhsubwave=r7nrshom if firstwavecind==6
replace anynhsubwave=r8nrshom if firstwavecind==7
replace anynhsubwave=r9nrshom if firstwavecind==8

recode anynhsubwave (.d=0) (.m=0) (.r=0)

gen anynh=anynhfirstwave==1 | anynhsubwave==1

** Any doctor's visit during last 2 years/since last wave
gen anydoctorfirstwave=.
forvalues wave=4/8 {
  replace anydoctorfirstwave=r`wave'doctor if firstwavecind==`wave'
}

recode anydoctorfirstwave (.d=0) (.m=0) (.r=0)

gen anydoctorsubwave=.
replace anydoctorsubwave=r5doctor if firstwavecind==4
replace anydoctorsubwave=r6doctor if firstwavecind==5
replace anydoctorsubwave=r7doctor if firstwavecind==6
replace anydoctorsubwave=r8doctor if firstwavecind==7
replace anydoctorsubwave=r9doctor if firstwavecind==8

recode anydoctorsubwave (.d=0) (.m=0) (.r=0)

gen anydoctor=anydoctorfirstwave==1 | anydoctorsubwave==1

** Medicaid insurance coverage
gen medicaid=.
forvalues wave=4/8 {
  replace medicaid=r`wave'govmd if firstwavecind==`wave'
}

recode medicaid (.d=0) (.m=0) (.r=0)

** Medicare insurance coverage
gen medicare=.
forvalues wave=4/8 {
  replace medicare=r`wave'govmr if firstwavecind==`wave'
}

recode medicare (.d=0) (.m=0) (.r=0)

** VA/Champus insurance coverage
gen vachampus=.
forvalues wave=4/8 {
  replace vachampus=r`wave'govva if firstwavecind==`wave'
}

recode vachampus (.d=0) (.m=0) (.r=0)

** Employer-sponsored coverage (either respondent or spouse's employer)
gen respempins=.
forvalues wave=4/8 {
  replace respempins=r`wave'covr if firstwavecind==`wave'
}

recode respempins (.c=1) (.e=1) (.d=0) (.m=0) (.r=0)

gen spouseempins=.
forvalues wave=4/8 {
  replace spouseempins=r`wave'covs if firstwavecind==`wave'
}

recode spouseempins (.c=1) (.e=1) (.d=0) (.m=0) (.r=0)

gen employerins=respempins==1 | spouseempins==1

** Create a variable with the year of the first positive score
gen firstpositiveyear=.
forvalues wave=4/8 {
  replace firstpositiveyear=r`wave'iwendy if firstwavecind==`wave'
}

save "X\eligiblecind2dxpeeps.dta", replace


******** Sensitivity analyses using the Medicare claims data *********

** Merge eligible dementia data file with cross walk to get beneficiary ID
use "X\EligibleDementiaPeeps.dta", clear
sort hhidpn
merge 1:1 hhidpn using "X\HRSMedicareLink.dta", gen(mergeMedicareID)
keep if mergeMedicareID==3
sort bid_hrs_21
save "X\TimelyDxDementiaCohort_05.09.20.dta", replace

** Now merge with the all years eligibility data to get dates of part A and B FFS coverage (person-level data file with Medicare identifier and one variable that summarizes FFS coverage from 1991-2012 - long string variable where each character represents a month and a 1 is "has FFS coverage" and 0 is "does not have FFS coverage")
merge 1:1 bid_hrs_21 using "X\MedicareEligibility1991_2012.dta", gen(mergeMedicareEnroll)
keep if mergeMedicareEnroll==3

** Limit to beneficiaries with first positive dates between 1992-2011 (if before 1992 or after 2011, bene could not have had the requisite amount of Medicare data)
drop if firstpositiveyear<1992
drop if firstpositiveyear>2011

** Determine which cases have the requisite amount of Medicare data to be eligible
gen eligiblecase=.
replace eligiblecase=1 if (substr(allyearseligibility,(year(firstpositivedate)-1991)*12+month(firstpositivedate)-12,25)=="1111111111111111111111111")
replace eligiblecase=0 if (substr(allyearseligibility,(year(firstpositivedate)-1991)*12+month(firstpositivedate)-12,25)!="1111111111111111111111111")
sort bid_hrs_21
save "X\TimelyDxDementiaCohort_05.09.20.dta", replace
clear

** Open the BASF and keep the final year of data for each bene
use "X\BASF_1991_2012.dta", clear
save "X\ccwdementiadx_05.09.20.dta", replace

keep bid_hrs_21 start_dt end_dt alzh alzh_demen alzh_ever alzh_demen_ever

gen year=year(start_dt)
by bid_hrs_21, sort: egen maxyear=max(year)

keep if year==maxyear
sort bid_hrs_21
save "X\ccwdementiadx_05.09.20.dta", replace
clear

** Merge the BASF data onto the dementia peeps data file
use "X\TimelyDxDementiaCohort_05.09.20.dta.dta", clear
merge 1:1 bid_hrs_21 using "X\ccwdementiadx_05.09.20.dta", gen(mergeCCW)
drop if mergeCCW==2

save "X\TimelyDxDementiaCohort_05.09.20.dta.dta", replace

** Create an indicator for any dementia dx
replace alzh_ever="" if alzh_ever=="00000000"
replace alzh_demen_ever="" if alzh_demen_ever=="00000000"
gen icd9dx=!missing(alzh_ever) | !missing(alzh_demen_ever)

** Determine date of icd9 dementia dx
gen alzhmth=substr(alzh_ever,5,2)
gen alzhday=substr(alzh_ever,7,2)
gen alzhyr=substr(alzh_ever,1,4)
destring alzhmth alzhday alzhyr, replace
gen firstalzhdate=mdy(alzhmth,alzhday,alzhyr)
format firstalzhdate %td

gen demenmth=substr(alzh_demen_ever,5,2)
gen demenday=substr(alzh_demen_ever,7,2)
gen demenyr=substr(alzh_demen_ever,1,4)
destring demenmth demenday demenyr, replace
gen firstdemendate=mdy(demenmth,demenday,demenyr)
format firstdemendate %td

gen icd9dxdate=firstalzhdate
replace icd9dxdate=firstdemendate if firstdemendate<firstalzhdate
format icd9dxdate %td

** Create indicator variable for outcome of ICD-9 dementia dx code either prior or within 1 year after first positive interview date
gen daysbtwn=icd9dxdate-firstpositivedate

gen timelyicd9dx=.
replace timelyicd9dx=0 if icd9dx==0
replace timelyicd9dx=0 if (daysbtwn!=. & daysbtwn>365)
replace timelyicd9dx=1 if (icd9dx==1 & daysbtwn<=365)
save "X\TimelyDxDementiaCohort_05.09.20.dta.dta", replace
