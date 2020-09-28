drop if year<2018
gen unemp=1 if empstat==21&22
gen labf=1 if labforce==2

gen year2= 12 if year== 2019
gen year3= 24 if year== 2020
mvencode year2 year3, mv(0)
gen year1= year2 + year3
gen yearmonth= month + year1

egen unemployment2 = sum( unemp), by(yearmonth)

plot unemployment2 yearmonth

egen labforce2 = sum( labf), by(yearmonth)
gen ratio2=  unemployment2/ labforce2

gen employment= 1- ratio2

preserve

restore

****EDUCATION
drop if educ==1
gen PreHS1=1 if educ <= 71
gen HS1=1 if educ >= 72 &  educ<= 110
gen College1=1 if educ >= 111 &  educ<= 122
gen PostCollege1=1 if educ >= 123 &  educ<= 125
mvencode PreHS1 HS1 College1 PostCollege1, mv(0)

egen PreHSunem = sum( unemp)  if PreHS1==1,  by(yearmonth)
egen HSunem = sum( unemp)  if HS1==1,  by(yearmonth)
egen Collegeunem = sum( unemp)  if College1==1,  by(yearmonth)
egen PostCollegeunem = sum( unemp)  if PostCollege1==1,  by(yearmonth)

egen PreHSlab = sum( labforce) if PreHS1==1, by(yearmonth)
egen HSlab = sum( labforce) if HS1==1, by(yearmonth)
egen Collegelab = sum( labforce) if College1==1, by(yearmonth)
egen PostCollegeHSlab = sum( labforce) if PostCollege1==1, by(yearmonth)

gen ratio3= PreHSunem/PreHSlab
gen ratio4= HSunem/HSlab
gen ratio5= Collegeunem/Collegelab
gen ratio6= PostCollegeunem/PostCollegeHSlab 

gen PreHS= 1-ratio3
gen HS= 1-ratio4
gen College= 1-ratio5
gen PostCollege= 1-ratio6

line PreHS HS College PostCollege yearmonth, legend(size(medsmall))


preserve
drop if ind==0

gen phy=1 if ind<=6390 | ind>=8560 & ind<=9180
gen tel=1 if ind>=9190 | ind<=8470 & ind>=6470
mvencode phy tel, mv(0)

egen u_phy= sum( unemp) if phy==1, by(yearmonth)
egen u_tel=sum( unemp) if tel==1, by(yearmonth)
egen l_phy=sum( labforce) if phy==1, by(yearmonth)
egen l_tel=sum( labforce) if tel==1, by(yearmonth)

gen ratio7=u_phy/l_phy
gen ratio8=u_tel/l_tel

gen physical=1-ratio7
gen telework=1-ratio8

line physical telework yearmonth, legend(size(medsmall))

restore
preserve 
drop if occ==0
gen Highoff=1 if occ<= 3540
gen offiPublic=1 if occ>= 3600 & occ<= 5940
gen Field=1 if occ>= 6000

egen Highoffunem = sum( unemp)  if Highoff==1,  by(yearmonth)
egen offiPublicunem = sum( unemp)  if offiPublic==1,  by(yearmonth)
egen Fieldunem= sum( unemp)  if Field==1,  by(yearmonth)

egen Highofflab = sum( labforce) if Highoff==1, by(yearmonth)
egen offiPubliclab = sum( labforce) if offiPublic==1, by(yearmonth)
egen Fieldlab = sum( labforce) if Field==1, by(yearmonth)

gen ratio9= Highoffunem/Highofflab
gen ratio10= offiPublicunem/offiPubliclab
gen ratio11= Fieldunem/Fieldlab

gen HighOffice= 1-ratio9
gen OfficePublic= 1-ratio10
gen Fieldwork= 1-ratio11

line HighOffice OfficePublic Fieldwork yearmonth, legend(size(medsmall))

 

ssc install asgen

asgen pre = employment if year!=2020, w(year) by(month)

sort yearmonth

replace pre = pre[250526] if yearmonth== 27
replace pre = pre[589595] if yearmonth== 28
replace pre = pre[743228] if yearmonth== 29
replace pre = pre[843428] if yearmonth== 30
replace pre = pre[968698] if yearmonth== 31
replace pre = pre[1068916] if yearmonth== 32

** replace pre = pre[year==2019] if yearmonth== 27&28&29&30&31&32


line employment pre yearmonth, legend(size(medsmall))


preserve

drop if uhrsworkt==997
drop if uhrsworkt==999

egen wh=mean(uhrsworkt), by(yearmonth)

asgen pre_wh=wh if year!=2020, w(year) by(month)
replace pre_wh = wh[223540] if yearmonth==27
replace pre_wh = wh[265078] if yearmonth==28
replace pre_wh = wh[328549] if yearmonth==29
replace pre_wh = wh[358420] if yearmonth==30
replace pre_wh = wh[444290] if yearmonth==31
replace pre_wh = wh[481623] if yearmonth==32

line wh pre_wh yearmonth


drop if empstat==0
gen empl=1 if  empstat<=12
egen emp=sum(empl), by(yearmonth)

gen agg_wh=emp*wh

asgen pre_agg_wh=agg_wh if year!=2020, w(year) by(month)
replace pre_agg_wh = agg_wh[223540] if yearmonth==27
replace pre_agg_wh = agg_wh[265078] if yearmonth==28
replace pre_agg_wh = agg_wh[328549] if yearmonth==29
replace pre_agg_wh = agg_wh[358420] if yearmonth==30
replace pre_agg_wh = agg_wh[444290] if yearmonth==31
replace pre_agg_wh = agg_wh[481623] if yearmonth==32

line agg_wh pre_agg_wh yearmonth, legend(size(medsmall))


gen percent_agg=(pre_agg_wh-agg_wh)/agg_wh if yearmonth>=27
gen empldesvi= (pre - employment)/ employment if yearmonth>=27
gen percent_wh=(pre_wh-wh)/wh if yearmonth>=27

restore
preserve

drop if hourwage== 999.99
egen meanWage= mean( hourwage), by (yearmonth)
line meanWage yearmonth

gen realwage2018= meanWage*0.679  if year==2018
gen realwage2019= meanWage*0.663  if year==2019
gen realwage2020= meanWage*0.652  if year==2020

mvencode realwage2018  realwage2019 realwage2020, mv(0)
gen realwage= realwage2019 + realwage2018 + realwage2020
line realwage yearmonth


asgen predicwage = realwage if year!=2020, w(year) by(month)

replace predicwage = predicwage[21899] if yearmonth== 27
replace predicwage = predicwage[32847] if yearmonth== 28
replace predicwage = predicwage[39817] if yearmonth== 29
replace predicwage = predicwage[52750] if yearmonth== 30
replace predicwage = predicwage[57728] if yearmonth== 31
replace predicwage = predicwage[61877] if yearmonth== 32

line realwage predicwage yearmonth
