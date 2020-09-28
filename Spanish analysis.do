import excel "C:\Users\USUARIO\Desktop\Master\2º Año\Quantitative Macroeconomics\exce 6.xlsx", sheet("Hoja1") firstrow
drop if year<=2017
gen employment= Total/ activo
line employment yearstrimes 

asgen pre = employment if year!=2020, w(year) by(Trimestre)

replace pre = pre[5] if yearstrimes== 26
replace pre = pre[6] if yearstrimes== 25

line employment pre yearstrimes, legend(size(medsmall))

***EDUCATION
gen PreHs= Analfabetos+ Estudiosprimariosincompletos+ Educacinprimaria
gen HS= Segundaetapadeeducacinsecund+ M
gen Superior= EducacinSuperior
gen  PreHsocu=  PreHs/ Totaleduc
gen  Hsocu=  HS/ Totaleduc
gen  Superiorocu=  Superior/ Totaleduc
 line PreHsocu Hsocu Superiorocu yearstrimes
 ***
gen agriculturocu= Agricultura/activo

 gen industrrocu= Industria/activo

gen Construccinocu= Construccin/activo

gen Serviciocu= Servicios/activo

line agriculturocu industrrocu Construccinocu Serviciocu yearstrimes
line agriculturocu industrrocu Construccinocu  yearstrimes
line Serviciocu  yearstrimes
line agriculturocu yearstrimes
line Construccinocu yearstrimes
line industrrocu yearstrimes

 gen Office= Directoresygerentes+ Tcnicosyprofesionalescient+ Tcnicosprofesionalesdeapoy+ Empleadoscontablesadministra
 
 gen Public= Trabajadoresdelosserviciosd
 
 gen Field= Trabajadorescualificadosenel+ Operadoresdeinstalacionesym+ Artesanosytrabajadorescualif+ Ocupacioneselementales+ Ocupacionesmilitares

 gen tOffice= Office/activo
 gen tPublic= Public/activo
 gen tField= Field/activo
 
 line tOffice tPublic tField yearstrimes,  legend(size(medsmall))
 
