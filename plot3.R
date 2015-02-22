## Exploratory Data Analysis: Course Project 2
## 2015-02-18 bankbintje
## Build and tested on 
# R version 3.1.2 
# R Studio Version 0.98.1062   
# Mac (x86_64-apple-darwin13.1.0)

plot3 <- function () {
        options(warn=-1)   
        
        # Clear all:
        rm(list=ls())
        
        # Load packages                 
        library(sqldf)        
        library(ggplot2)
        
        ## Load data
        NEI <- readRDS("summarySCC_PM25.rds")
        
        ## Calculate relevant values
        NEI_subset <- sqldf("select year, type,
                    sum(Emissions) as Sum_Emissions
                    from NEI 
                    where fips = 24510
                    group by year, type")
        
        ## open a graphics device
        png(filename = "plot3.png", 
            width = 480, 
            height = 480, 
            units = "px", 
            bg = "white" )
        
        ## Make a ggplot 
        print(
                ggplot(data=NEI_subset, aes(x=factor(year), y=Sum_Emissions,fill=type)) + 
                        geom_bar(stat="identity") +
                        facet_wrap (~type, ncol=2, scales = "free") +
                        scale_fill_brewer(palette="Set1") +
                        xlab ("Year") +
                        ylab ("Total PM2.5 emitted (tons)") +
                        ggtitle ("Total PM2.5 Emissions 1999-2008 in Baltimore City per Type")
        )
        ## close the device...
        dev.off()
        
        ## ..and clean up
        rm(list=ls())
        
}