*************************************************************************************************
* Do file for analysis for Factors Associated with Timely Dementia Diagnosis study
*************************************************************************************************

** Start with the incident dementia cohort (eligible dementia means dementia dx + valid prior wave)
use "X\EligibleDementiaPeeps.dta", clear

** Limit analysis to people with any health care touches in the prior 2 years
gen anyvisit=anydoctor==1 | anyhosp==1 | anynh==1
tab anyvisit

** Need to explore missingness for the covariates among those that are eligible and have a health care touch
summarize agedementiadx if anyvisit==1
summarize numconditions if anyvisit==1
summarize numinhouse if anyvisit==1
tab1 male race education marital livealone selfhealth medicaid medicare vachampus respempins spouseempins employerins if anyvisit==1, missing

** Create indicator for missing data
gen missingdata=race==. | marital==.m | selfhealth==9
tab missingdata if anyvisit==1

** Create a categorical variable for age at dx
gen agedementiadxcat=.
replace agedementiadxcat=1 if agedementiadx<65
replace agedementiadxcat=2 if agedementiadx>=65 & agedementiadx<75
replace agedementiadxcat=3 if agedementiadx>=75 & agedementiadx<85
replace agedementiadxcat=4 if agedementiadx>=85

save "X\EligibleDementiaPeeps.dta", replace

** Now carry out analysis only among those that have any health care touch and are not missing data
** % of incident dementia cases with timely diagnosis
tabulate concurrentdementiadx if anyvisit==1 & missingdata==0, missing

** Explore characteristics of those with a timely dementia diagnosis vs those with a delayed diagnosis
ttest agedementiadx if anyvisit==1 & missingdata==0, by(concurrentdementiadx)
ttest numconditions if anyvisit==1 & missingdata==0, by(concurrentdementiadx)

tab firstpositiveproxy concurrentdementiadx if anyvisit==1 & missingdata==0, col chi2
tab agedementiadxcat concurrentdementiadx if anyvisit==1 & missingdata==0, col chi2
tab male concurrentdementiadx if anyvisit==1 & missingdata==0, col chi2
tab race concurrentdementiadx if anyvisit==1 & missingdata==0, col chi2
tab education concurrentdementiadx if anyvisit==1 & missingdata==0, col chi2
tab marital concurrentdementiadx if anyvisit==1 & missingdata==0, col chi2
tab livealone concurrentdementiadx if anyvisit==1 & missingdata==0, col chi2
tab poorselfhealth concurrentdementiadx if anyvisit==1 & missingdata==0, col chi2
tab anyhosp concurrentdementiadx if anyvisit==1 & missingdata==0, col chi2
tab anynh concurrentdementiadx if anyvisit==1 & missingdata==0, col chi2
tab anydoctor concurrentdementiadx if anyvisit==1 & missingdata==0, col chi2
tab medicare concurrentdementiadx if anyvisit==1 & missingdata==0, col chi2
tab medicaid concurrentdementiadx if anyvisit==1 & missingdata==0, col chi2
tab vachampus concurrentdementiadx if anyvisit==1 & missingdata==0, col chi2
tab employerins concurrentdementiadx if anyvisit==1 & missingdata==0, col chi2

tab concurrentdementiadx race if anyvisit==1 & missingdata==0, nolabel col chi2
tab concurrentdementiadx education if anyvisit==1 & missingdata==0, nolabel col chi2

** Final model - with firstpositiveproxy
logistic concurrentdementiadx i.agedementiadxcat male black hispanic otherrace lesshsgrad hsgrad somecollege livealone firstpositiveproxy firstpositiveyear ///
poorselfhealth numconditions anyhosp anynh medicare medicaid vachampus employerins if anyvisit==1 & missingdata==0

** Final model - without firstpositiveproxy
logistic concurrentdementiadx i.agedementiadxcat male black hispanic otherrace lesshsgrad hsgrad somecollege livealone firstpositiveyear ///
poorselfhealth numconditions anyhosp anynh medicare medicaid vachampus employerins if anyvisit==1 & missingdata==0

** Next, use the incident CIND cohort (eligible CIND means cinddx==1 & normalpriorwave==1)
use "X\eligiblecindpeeps.dta", clear

** Limit analysis to people with any health care touches in the prior 2 years
gen anyvisit=anydoctor==1 | anyhosp==1 | anynh==1
tab anyvisit

** Need to explore missingness for the covariates among those that are eligible and have a health care touch
summarize agecinddx if anyvisit==1
summarize numconditions if anyvisit==1
summarize numinhouse if anyvisit==1
tab1 male race education marital livealone selfhealth medicaid medicare vachampus respempins spouseempins employerins anyhosp anynh if anyvisit==1, missing

** Create indicator for missing data
gen missingdata=numconditions==.m | race==. | education==.m | marital==.m | selfhealth==9 | anyhosp==.r | anynh==.r
tab missingdata if anyvisit==1

** Create a categorical variable for age at dx
gen agecinddxcat=.
replace agecinddxcat=1 if agecinddx<65
replace agecinddxcat=2 if agecinddx>=65 & agecinddx<75
replace agecinddxcat=3 if agecinddx>=75 & agecinddx<85
replace agecinddxcat=4 if agecinddx>=85

save "X\eligiblecindpeeps.dta", replace

** % of incident CIND cases with timely diagnosis
tabulate concurrentcinddx if anyvisit==1 & missingdata==0, missing

** Explore characteristics of those with a timely CIND diagnosis vs those with a delayed diagnosis
ttest agecinddx if anyvisit==1 & missingdata==0, by(concurrentcinddx)
ttest numconditions if anyvisit==1 & missingdata==0, by(concurrentcinddx)

tab firstpositiveproxy concurrentcinddx if anyvisit==1 & missingdata==0, col chi2
tab agecinddxcat concurrentcinddx if anyvisit==1 & missingdata==0, col chi2
tab male concurrentcinddx if anyvisit==1 & missingdata==0, col chi2
tab race concurrentcinddx if anyvisit==1 & missingdata==0, col chi2
tab education concurrentcinddx if anyvisit==1 & missingdata==0, col chi2
tab marital concurrentcinddx if anyvisit==1 & missingdata==0, col chi2
tab livealone concurrentcinddx if anyvisit==1 & missingdata==0, col chi2
tab poorselfhealth concurrentcinddx if anyvisit==1 & missingdata==0, col chi2
tab anyhosp concurrentcinddx if anyvisit==1 & missingdata==0, col chi2
tab anynh concurrentcinddx if anyvisit==1 & missingdata==0, col chi2
tab anydoctor concurrentcinddx if anyvisit==1 & missingdata==0, col chi2
tab medicare concurrentcinddx if anyvisit==1 & missingdata==0, col chi2
tab medicaid concurrentcinddx if anyvisit==1 & missingdata==0, col chi2
tab vachampus concurrentcinddx if anyvisit==1 & missingdata==0, col chi2
tab employerins concurrentcinddx if anyvisit==1 & missingdata==0, col chi2

tab concurrentcinddx race if anyvisit==1 & missingdata==0, nolabel col chi2
tab concurrentcinddx education if anyvisit==1 & missingdata==0, nolabel col chi2

** Final model - with firstpositiveproxy
logistic concurrentcinddx i.agecinddxcat male black hispanic otherrace lesshsgrad hsgrad somecollege livealone firstpositiveproxy firstpositiveyear ///
poorselfhealth numconditions anyhosp anynh medicare medicaid vachampus employerins if anyvisit==1 & missingdata==0

** Final model - without firstpositiveproxy
logistic concurrentcinddx i.agecinddxcat male black hispanic otherrace lesshsgrad hsgrad somecollege livealone firstpositiveyear ///
poorselfhealth numconditions anyhosp anynh medicare medicaid vachampus employerins if anyvisit==1 & missingdata==0

** Next use the alternate CIND cohort (dx at two consecutive waves)
** Open the updated incident CIND cohort (eligible means cinddx==1 & normalpriorwave==1 & cindsubsequentwave==1)
use "X\eligiblecind2dxpeeps.dta", clear

** Limit analysis to people with any health care touches in the prior 4 years
gen anyvisit=anydoctor==1 | anyhosp==1 | anynh==1
tab anyvisit

** Need to explore missingness for the covariates among those that are eligible and have a health care touch
summarize agecinddx if anyvisit==1
summarize numconditions if anyvisit==1
summarize numinhouse if anyvisit==1
tab1 male race education marital livealone selfhealth medicaid medicare vachampus respempins spouseempins employerins anyhosp anynh if anyvisit==1, missing

** Create indicator for missing data 
gen missingdata=marital==.m
tab missingdata if anyvisit==1

** Create a categorical variable for age at dx
gen agecinddxcat=.
replace agecinddxcat=1 if agecinddx<65
replace agecinddxcat=2 if agecinddx>=65 & agecinddx<75
replace agecinddxcat=3 if agecinddx>=75 & agecinddx<85
replace agecinddxcat=4 if agecinddx>=85

save "X\eligiblecind2dxpeeps.dta", replace

** % of incident cases with timely diagnosis
tabulate concurrentcinddx2dx if anyvisit==1 & missingdata==0, missing

** Explore characteristics of those with a timely diagnosis vs those with a delayed diagnosis
ttest agecinddx if anyvisit==1 & missingdata==0, by(concurrentcinddx2dx)
ttest numconditions if anyvisit==1 & missingdata==0, by(concurrentcinddx2dx)

tab firstpositiveproxy concurrentcinddx2dx if anyvisit==1 & missingdata==0, col chi2
tab agecinddxcat concurrentcinddx2dx if anyvisit==1 & missingdata==0, col chi2
tab male concurrentcinddx2dx if anyvisit==1 & missingdata==0, col chi2
tab race concurrentcinddx2dx if anyvisit==1 & missingdata==0, col chi2
tab education concurrentcinddx2dx if anyvisit==1 & missingdata==0, col chi2
tab marital concurrentcinddx2dx if anyvisit==1 & missingdata==0, col chi2
tab livealone concurrentcinddx2dx if anyvisit==1 & missingdata==0, col chi2
tab poorselfhealth concurrentcinddx2dx if anyvisit==1 & missingdata==0, col chi2
tab anyhosp concurrentcinddx2dx if anyvisit==1 & missingdata==0, col chi2
tab anynh concurrentcinddx2dx if anyvisit==1 & missingdata==0, col chi2
tab anydoctor concurrentcinddx2dx if anyvisit==1 & missingdata==0, col chi2
tab medicare concurrentcinddx2dx if anyvisit==1 & missingdata==0, col chi2
tab medicaid concurrentcinddx2dx if anyvisit==1 & missingdata==0, col chi2
tab vachampus concurrentcinddx2dx if anyvisit==1 & missingdata==0, col chi2
tab employerins concurrentcinddx2dx if anyvisit==1 & missingdata==0, col chi2

tab concurrentcinddx2dx race if anyvisit==1 & missingdata==0, nolabel col chi2
tab concurrentcinddx2dx education if anyvisit==1 & missingdata==0, nolabel col chi2

tab anyhospfirstwave concurrentcinddx2dx if anyvisit==1 & missingdata==0, col chi2
tab anynhfirstwave concurrentcinddx2dx if anyvisit==1 & missingdata==0, col chi2

** Final model - with firstpositiveproxy
logistic concurrentcinddx2dx i.agecinddxcat male black hispanic otherrace lesshsgrad hsgrad somecollege livealone firstpositiveproxy firstpositiveyear ///
poorselfhealth numconditions anyhosp anynh medicare medicaid vachampus employerins if anyvisit==1 & missingdata==0

** Final model - without firstpositiveproxy
logistic concurrentcinddx2dx i.agecinddxcat male black hispanic otherrace lesshsgrad hsgrad somecollege livealone firstpositiveyear ///
poorselfhealth numconditions anyhosp anynh medicare medicaid vachampus employerins if anyvisit==1 & missingdata==0

test 2.agecinddxcat 3.agecinddxcat 4.agecinddxcat
test black hispanic otherrace
test lesshsgrad hsgrad somecollege

** Final model - without firstpositiveproxy (health care utilization defined at first qualifying wave)
logistic concurrentcinddx2dx i.agecinddxcat male black hispanic otherrace lesshsgrad hsgrad somecollege livealone firstpositiveyear ///
poorselfhealth numconditions anyhospfirstwave anynhfirstwave medicare medicaid vachampus employerins if anyvisit==1 & missingdata==0

test 2.agecinddxcat 3.agecinddxcat 4.agecinddxcat
test black hispanic otherrace
test lesshsgrad hsgrad somecollege

******** Sensitivity Analysis using the Medicare claims data ********
use "X\TimelyDxDementiaCohort_05.09.20.dta.dta", clear

** Final model - with firstpositiveproxy
logistic timelyicd9dx i.agedementiadxcat male black hispanic otherrace lesshsgrad hsgrad somecollege livealone firstpositiveproxy firstpositiveyear ///
poorselfhealth numconditions anyhosp anynh medicare medicaid vachampus employerins if eligiblecase==1 & anyvisit==1 & missingdata==0

** Final model - without firstpositiveproxy
logistic timelyicd9dx i.agedementiadxcat male black hispanic otherrace lesshsgrad hsgrad somecollege livealone firstpositiveyear ///
poorselfhealth numconditions anyhosp anynh medicare medicaid vachampus employerins if eligiblecase==1 & anyvisit==1 & missingdata==0
