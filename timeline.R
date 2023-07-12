#install.packages("timevis")
library(timevis)

data <- data.frame(
  id      = 1:2,
  content = c("Lima", "Huanuco"),
  start   = c("2014-04", "2014-11"),
  end =c("2015-1", "2016-3"))

timevis(data)
timevis(data , showZoom = FALSE, 
        options = list(orientation = "bottom"))




data2 <- data.frame(
  id      = 1:18,
  content = c("Lima", "Huanuco", "La Libertad, Loreto, Cajamarca, Ica, Moquegua, y Tumbes", "Ancash", "Arequipa", "Cusco", "Piura", "Callao y Lambayeque", "Ayacucho y Puno", "San Martin", "Juni­n", "Pasco", "Madre de Dios", "Huancavelica", "Amazonas", "Apuri­mac", "Ucayali", "Tacna" ),
  start   = c("2014-04", "2014-11", "2014-12", "2015-01", "2016-10", "2017-07", "2017-10", "2017-11", "2018-04", "2019-04", "2019-05", "2019-09", "2019-10", "2020-08", "2020-09", "2020-10", "2020-11", "2020-12")
)
timevis(data2 , showZoom = FALSE, 
        options = list(orientation = "bottom"))




data3 <- data.frame(
  id      = 1:9,
  content = c("Lima", "La Libertad, Loreto, Cajamarca, Ica, Moquegua, y Tumbes",  "Cusco",  "Callao y Lambayeque",  "San Martin",   "Pasco",  "Huancavelica",  "Apuri­mac",  "Tacna" ),
  start   = c("2014-04", "2014-12", 							   "2017-07",  "2017-11",  		 "2019-04",  	"2019-09",  "2020-08", 	   "2020-10",  "2020-12")
)
timevis(data3 , showZoom = FALSE, 
        options = list(orientation = "bottom"),
	width = "1000px", height = "200px")




data4 <- data.frame(
  id      = 1:9,
  content = c("Huanuco", "Ancash", "Arequipa", "Piura", "Ayacucho y Puno",  "Juni­n", "Madre de Dios",  "Amazonas", "Ucayali"),
  start   = c("2014-11", "2015-01", "2016-10", "2017-10",  "2018-04",	   "2019-05", "2019-10", 	 "2020-09",  "2020-11")
)
timevis(data4 , showZoom = FALSE, 
        options = list(orientation = "top"),
	width = "1200px", height = "200px")


