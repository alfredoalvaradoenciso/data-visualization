
library(xlsx)
data <- read.xlsx("C:/Users/Dell/Documents/GitHub/data-visualization/vacantes4.xlsx", sheetIndex = 1, stringsAsFactors = FALSE, encoding="UTF-8")

library(xtable)
library(dplyr)

#Remove commas from numeric values in number columns
data$c5_p13 <- gsub(",","", data$c5_p13)

#Convert numeric columns to a numeric data type
data$c5_p13 <- as.numeric(data$c5_p13)

#Create new data frame for positive (spending) values
data$n2 <- paste(data$ciuo1, data$pc4, sep = ", ")
spending <- data %>% select(n, n2, c5_p13) 

library(treemap)
treemap(spending, #Your data frame object
        index="n2",  #A list of your categorical variables
        vSize = "c5_p13",  #This is your quantitative variable
        type="index", #Type sets the organization and color scheme of your treemap
        palette = "-Set3",  #Select your color palette from the RColorBrewer presets or make your own.
        title="", #Customize your title
        fontsize.title = 14, #Change the font size of the title
        inflate.labels = TRUE,
        fontsize.labels=1,
        lowerbound.cex.labels=1,       
        force.print.labels=TRUE,
        overlap.labels = 1
)