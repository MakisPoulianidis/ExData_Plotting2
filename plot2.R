## Exploratory Data Analysis: Course Project 2
## 2015-02-15 bankbintje
## Build and tested on 
# R version 3.1.2 
# R Studio Version 0.98.1062   
# Mac (x86_64-apple-darwin13.1.0)

plot2 <- function () {
        options(warn=-1)   

        # Clear all:
        rm(list=ls())
        
# Load packages         
        
library(dplyr)
library(sqldf)        
        
## Load data

NEI <- readRDS("summarySCC_PM25.rds")
dplyr::tbl_df(NEI)

## Calculate relevant values
NEI_subset <- sqldf("select year, 
                    sum(Emissions) as Sum_Emissions
                    from NEI 
                    where fips = 24510
                    group by year")

## convert year to numeric
NEI_subset$year <- as.numeric(NEI_subset$year)


## open a graphics device
png(filename = "plot2.png", 
    width = 480, 
    height = 480, 
    units = "px", 
    bg = "white" )

## Make a base plot using type = "b"
plot(NEI_subset$year, 
     NEI_subset$Sum_Emissions, 
     type = "b", 
     col="red", 
     xlab = "Year", 
     ylab = "total PM2.5 emitted (tons)",
     main="Total PM2.5 Emissions 1999-2008 in Baltimore City")

## close the device...
dev.off()

## ..and clean up
rm(list=ls())

}