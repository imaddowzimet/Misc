
capture program drop calcdist  // drop program, if it already exists
program define calcdist        // define program called calcdist

* The user needs to input the following syntax:
syntax newvarname, lon1(varname) lon2(varname) lat1(varname) lat2(varname)  // latitudes and longitudes need to be entered in degrees

* Program:

* define radius of earth
local R = 6371000 // this is the radius of the earth in meters

* convert latitudes and longitudes to radians
local degree `lon1' `lon2' `lat1' `lat2'
local name lon1 lon2 lat1 lat2
foreach mynum of numlist 1/4 {
local myname: word `mynum' of `name'
local mydegree: word `mynum' of `degree'
gen `myname'rad=`mydegree'*(_pi/180)
}

* calculate change in longitude and latitude
gen deltalat=lat2rad-lat1rad
gen deltalon=lon2rad-lon1rad

* haversine formula
gen alphaterm = (sin(deltalat/2))^2 + cos(lat1rad) * cos(lat2rad) * (sin(deltalon/2))^2
gen gammaterm = 2 * atan2(sqrt(alphaterm), sqrt(1-alphaterm))
gen distancemeters = `R' * gammaterm

* create final variable, in miles
gen `varlist' = distancemeters* (0.000621371)

* drop extra variables we created
drop lat2rad lat1rad lon2rad lon1rad deltalat deltalon alphaterm gammaterm distancemeters

end
