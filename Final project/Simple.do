clear all

*Install the following pakages if you need them:
*ssc install ivreg2
*ssc install ranktest
*scc install xttest3
 *** Initial Graphs 
 
 *Write here your directoy
 cd "C:\Users\victo\OneDrive\Desktop\Master\2º Año\Quantitative Macroeconomics\Final"

import excel "C:\Users\victo\OneDrive\Desktop\Master\2º Año\Quantitative Macroeconomics\Final\Datos Stata.xlsx", sheet("Hoja1") firstrow
drop if Tipo==2
gen Infra= R - Otros
rename Población Poblacin
gen Pibcapita = PIB/ Poblacin
gen Capitalcapita= Capital/ Poblacin
gen Infracaptial= Infra/ Poblacin
gen Capper2 = Capitalcapita - Infracaptial
gen LPibcapita = log(PIB/ Poblacin)
gen LCapitalcapita= log(Capital/ Poblacin)
gen LInfracaptial= log(Infra/ Poblacin)
gen LCapper2 = log(Capper2)
xtset CCAA Año
xtline LPibcapita if CCAA==1 | CCAA==9 | CCAA==11 | CCAA==13 | CCAA==16 | CCAA==7, overlay
xtline LCapitalcapita if CCAA==1 | CCAA==9 | CCAA==11 | CCAA==13 | CCAA==16 | CCAA==7, overlay

clear all
 
import excel "C:\Users\victo\OneDrive\Desktop\Master\2º Año\Quantitative Macroeconomics\Final\Datos Stata.xlsx", sheet("Hoja1") firstrow


****
drop if Tipo == 1
* I create the variable which represent all the capital in infrastructures 
*by subtracting Otros (building not infrastructures nor houses) from R (Building no houses)  
gen Infra= R - Otros

*Now, we transform all the variables in per capital terms. 
rename Población Poblacin
rename Extensión Extensin

gen Pibcapita = PIB/ Poblacin

gen Capitalcapita= Capital/ Poblacin

gen Infracaptial= Infra/ Poblacin

gen Roadscapita= InfViarias/ Poblacin

gen Hydraucapita= InfHidrau/ Poblacin

gen Railwayscapita= InfFerrov/ Poblacin

gen Aerportcapita= InfAeropuer/ Poblacin

gen Portcapita= InfPortua/ Poblacin

gen Urbancapita= InfrUrba/ Poblacin

gen Capper2 = Capitalcapita - Infracaptial



** We transform all the variables in log terms. 
gen LPibcapita = log(PIB/ Poblacin)

gen LCapitalcapita= log(Capital/ Poblacin)

gen LInfracaptial= log(Infra/ Poblacin)

gen LRoadscapita= log(InfViarias/ Poblacin)

gen LHydraucapita= log(InfHidrau/ Poblacin)

gen LRailwayscapita= log(InfFerrov/ Poblacin)

gen LAerportcapita= log(InfAeropuer/ Poblacin)

gen LPortcapita= log(InfPortua/ Poblacin)

gen LUrbancapita= log(InfrUrba/ Poblacin)

gen LCapper2 = log(Capper2)


* Population Density
gen Density= Poblacin/ Extensin
gen LDensity= log(Density)

 mvdecode _all, mv(0)
 mvencode _all, mv(0)

 **Capital
 gen byte Capi= 1 if N== 9|  N==13 |  N==14 |  N==15|  N==17 |  N==18|  N==19 |  N==28 |  N==35 |  N==37 |  N==44 |  N==46 |  N==53 |  N==54|   N==55 |  N==57 |  N==60
 mvencode Capi, mv(0)
 gen capicapital= Capi* LCapitalcapita
 gen capicapi2= Capi* LCapper2
 
 **Sectors
 
gen agriculture= Agricultura/ TOTAl

gen industry= Industria/ TOTAl

gen construction= Construcción/ TOTAl

gen service = Servicios/ TOTAl


*** REGRESIONS (1)
regress Pibcapita Capitalcapita
twoway scatter Pibcapita Capitalcapita || lfit Pibcapita Capitalcapita
estat hettest

regress Pibcapita Capitalcapita, robust


regress LPibcapita LCapitalcapita
estat hettest
estimates store OLSbasic

regress LPibcapita  LCapper2 LInfracaptial
estat hettest
estimates store OLS2 
ivreg2  LPibcapita  (LInfracaptial = LCapper2), first robust

regress LPibcapita  LCapper2 LInfracaptial LDensity
estat hettest
regress LPibcapita  LCapper2 LInfracaptial LDensity, robust
gen deninfra= LInfracaptial*LDensity
estimates store OLS3
regress LPibcapita  LCapper2 LInfracaptial LDensity deninfra, robust
vif
regress LPibcapita  LCapper2 LInfracaptial LDensity agriculture industry service , robust
vif
regress LPibcapita  LCapper2 LInfracaptial LDensity construction service industry , robust
vif
estimates store OLS4

regress LPibcapita LCapper2 LInfracaptial LDensity  construction service industry Capi, robust
vif
estimates store OLS5

regress LPibcapita LCapper2 LInfracaptial LDensity  construction service industry Capi i.Año, robust
vif
estimates store OLS6



xtset N Año
xi: xtreg LPibcapita LCapper2 LInfracaptial , fe
xttest3
xtreg LPibcapita LCapper2 LInfracaptial , fe robus
estimates store FEbasic
xtreg LPibcapita LCapper2 LInfracaptial construction service industry , fe
estimates store fixed
xttest3
xtreg LPibcapita LCapper2 LInfracaptial construction service industry Capi, re
estimates store random
hausman fixed random

xtreg LPibcapita LCapper2 LInfracaptial construction service industry, fe robust
estimates store FE2


xtreg LPibcapita LCapper2 LInfracaptial construction service industry i.Año, fe robust
estimates store FE3

estimates table OLSbasic OLS2 OLS3  OLS4  OLS5  OLS6 FEbasic FE2 FE3, star stats(N r2 r2_a)

**** REgresions (2)
 gen Capiininfra= LInfracaptial*Capi
 gen densiinfra =  LInfracaptial* Density
 gen Infraconstr=  construction* LInfracaptial
gen Infraserv=  service* LInfracaptial
 gen Infraindust= industry * LInfracaptial
 
 regress LPibcapita LCapper2 LInfracaptial LDensity construction service industry Capi Capiininfra, robust
 vif
 regress LPibcapita LCapper2 LInfracaptial LDensity  construction service industry Capi densiinfra , robust
 vif
 
 
 regress LPibcapita LCapper2 LInfracaptial densiinfra Capiininfra industry construction service , robust
 vif
 estimates store Interaction1
 regress LPibcapita LCapper2 LInfracaptial densiinfra Capiininfra industry construction service i.Año , robust
 vif
 regress LPibcapita LCapper2 LInfracaptial densiinfra Capiininfra industry construction service i.Año i.N, robust
 estimates store Interaction2
 estimates table Interaction1 Interaction2, star stats(N r2 r2_a)



**** Regression (4)

gen raildensity= Railwayscapita* Density
gen Railcapi= Railwayscapita* Capi


gen roaddensity= Roadscapita* Density
gen Roadcapi= Roadscapita* Capi

gen hyddensity= Hydraucapita* Density
gen hydcapi= Hydraucapita* Capi

gen airdensity= Aerportcapita* Density
gen aircapi= Aerportcapita* Capi

gen portdensity= Portcapita* Density
gen portcapi= Portcapita* Capi

gen urbdensity= Urbancapita* Density
gen urbcapi= Urbancapita* Capi

gen yMar= Pibper*Mar

regress yMar Capper2 Roadscapita Hydraucapita Railwayscapita Aerportcapita Portcapita Urbancapita Railcapi raildensity ,  robust 
vif

regress Pibcapita Capper2 Roadscapita Hydraucapita Railwayscapita Aerportcapita Portcapita Urbancapita i.Año i.N, robust 
global sector agriculture industry construction
regress Pibcapita Capper2 Roadscapita Hydraucapita Railwayscapita Aerportcapita Portcapita Urbancapita $sector i.Año i.N, robust 
regress Pibcapita Capper2 Roadscapita Hydraucapita Railwayscapita Aerportcapita Portcapita Urbancapita  i.Año i.N Density , robust 



*Final regressions:

 global sector agriculture industry construction
 regress LPibcapita LCapper2 LInfracaptial i.Año i.N, robust
 estimates store In1 
 
 regress LPibcapita LCapper2 LInfracaptial densiinfra Capiininfra i.Año i.N, robust
 estimates  store In2
 
  regress LPibcapita LCapper2 LInfracaptial densiinfra Capiininfra $sector i.Año i.N, robust
  estimates  store In3
  
  esttab In1 In2 In3 using Anexes1/Infra.tex, starlevels( * 0.10 ** 0.05 *** 0.010) se ar2 tex replace ///
title("Aggregated Infrastructures"\label{reg22})  keep( LCapper2 LInfracaptial densiinfra Capiininfra $sector)	///
nonumbers mtitles("(1)" "(2)" "(3)" )

 regress LPibcapita LCapper2 LRoadscapita LHydraucapita LRailwayscapita LAerportcapita LPortcapita LUrbancapita i.Año , robust
 estimates store OLS
 regress LPibcapita LCapper2 LRoadscapita LHydraucapita LRailwayscapita LAerportcapita LPortcapita LUrbancapita i.Año i.N, robust
 vif
 estimates store Sepa1
  regress LPibcapita LCapper2 LRoadscapita LHydraucapita LRailwayscapita LAerportcapita LPortcapita LUrbancapita Density i.Año i.N, robust
 estimates store Sepa2
 regress LPibcapita LCapper2 LRoadscapita LHydraucapita LRailwayscapita LAerportcapita LPortcapita LUrbancapita Density  $sector i.Año i.N, robust
 estimates store Sepa3
 
 regress LPibcapita LCapper2 LRoadscapita LHydraucapita LRailwayscapita LAerportcapita LPortcapita LUrbancapita Density $sector i.Año i.N if Mar==1 & LAerportcapita!=.
  estimates store Sepa4 , robust 
  esttab OLS Sepa1 Sepa2 Sepa3 Sepa4  using Anexes1/SepaInfra.tex, starlevels( * 0.10 ** 0.05 *** 0.010)  se ar2 tex replace ///
title("Separeted Infrastructures"\label{reg22})  keep( LCapper2 LRoadscapita LHydraucapita LRailwayscapita LAerportcapita LPortcapita LUrbancapita Density  $sector )	///
nonumbers mtitles("(1)" "(2)" "(3)"  "(4)"  "(5)")


**Graphs
xtline LPibcapita LCapitalcapita if N==53 | N==47
xtline LPibcapita if N==53 | N==47 | N==15 | N==46, overlay
xtline LCapitalcapita if N==53 | N==47 | N==15 | N==46, overlay

twoway scatter  industry construction service
twoway scatter agriculture construction service


 twoway scatter  LPibcapita LRailwayscapita
 twoway scatter  LPibcapita LPortcapita
twoway scatter  LPibcapita LAerportcapita
 
twoway scatter Pibcapita  Railwayscapita



/**Tables
drop if Año==1965
gen byte Sur=1 if CCAA==1|CCAA==7|CCAA==5|CCAA==10|CCAA==11|CCAA==15
mvencode Sur, mv(0)
tabstat Pibcre Capicr2 InfraesCRE , by(Sur) stat(mean sd n)

*** PORT PROBLEM
drop if Mar== 0

regress Pibcapita Capper2 Roadscapita Hydraucapita Railwayscapita Aerportcapita Portcapita Urbancapita, robust
estimates store OLS10
regress Pibcapita Capper2 Roadscapita Hydraucapita Railwayscapita Aerportcapita Portcapita Urbancapita Density Capi industry construction service, robust
vif
estimates store OLS11
regress Pibcapita Capper2 Roadscapita Hydraucapita Railwayscapita Aerportcapita Portcapita Urbancapita Density Capi industry construction service i.Año, robust
vif
estimates store OLS12

xtreg Pibcapita Capper2 Roadscapita Hydraucapita Railwayscapita Aerportcapita Portcapita Urbancapita, fe robust
 estimates store Fe7
 xtreg Pibcapita Capper2 Roadscapita Hydraucapita Railwayscapita Aerportcapita Portcapita Urbancapita industry construction service, fe robust
 estimates store Fe8
 xtreg Pibcapita Capper2 Roadscapita Hydraucapita Railwayscapita Aerportcapita Portcapita Urbancapita industry construction service i.Año, fe robust
 estimates store Fe9
 
 estimates table OLS10 OLS11 OLS12 Fe7 Fe8 Fe9, star stats(N r2 r2_a)

 */

 ****INOVACIONES****


