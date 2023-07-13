
library(xlsx)
data <- read.xlsx("C:/Users/Dell/Downloads/vacantes.xlsx", sheetIndex = 1, stringsAsFactors = FALSE, encoding="UTF-8")

library(xtable)
library(dplyr)

#Remove commas from numeric values in number columns
data$c5_p9_3_1 <- gsub(",","", data$c5_p9_3_1)

#Convert numeric columns to a numeric data type
data$c5_p9_3_1 <- as.numeric(data$c5_p9_3_1)

#Create new data frame for positive (spending) values
data$n2 <- paste(data$n, data$pc3, sep = ", ")
spending <- data %>% select(ciuo1, n2, c5_p9_3_1) %>%
  group_by(ciuo1, n2) %>%
  summarize(c5_p9_3_1 = sum(c5_p9_3_1, na.rm=FALSE)) %>%
  filter(c5_p9_3_1 > 0)

library(treemap)
treemap(spending, #Your data frame object
        index=c("ciuo1","n2"),  #A list of your categorical variables
        vSize = "c5_p9_3_1",  #This is your quantitative variable
        type="index", #Type sets the organization and color scheme of your treemap
        palette = "-RdBu",  #Select your color palette from the RColorBrewer presets or make your own.
        title="Vacantes requeridas seg?n grupos de ocupaciones", #Customize your title
        fontsize.title = 14, #Change the font size of the title
inflate.labels = TRUE,
 fontsize.labels=c(0,1),
lowerbound.cex.labels=1,       
force.print.labels=FALSE
)