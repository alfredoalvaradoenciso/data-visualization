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
  content = c("Lima", "Huanuco", "La Libertad, Loreto, Cajamarca, Ica, Moquegua, y Tumbes", "Ancash", "Arequipa", "Cusco", "Piura", "Callao y Lambayeque", "Ayacucho y Puno", "San Martin", "Junin", "Pasco", "Madre de Dios", "Huancavelica", "Amazonas", "Apurimac", "Ucayali", "Tacna" ),
  start   = c("2014-04", "2014-11", "2014-12", "2015-01", "2016-10", "2017-07", "2017-10", "2017-11", "2018-04", "2019-04", "2019-05", "2019-09", "2019-10", "2020-08", "2020-09", "2020-10", "2020-11", "2020-12")
)
timevis(data2 , showZoom = FALSE, 
        options = list(orientation = "bottom"))