## Exploratory Data Analysis: Course Project 2
## 2015-02-22 bankbintje
## Build and tested on 
# R version 3.1.2 
# R Studio Version 0.98.1062   
# Mac (x86_64-apple-darwin13.1.0)

plot4 <- function () {
        options(warn=-1)           
        # Clear all:
        rm(list=ls())        
        # Load packages                 
        library(sqldf)        
        library(ggplot2)
        
        
        ## Load data
        NEI <- readRDS("summarySCC_PM25.rds")
        SCC <- readRDS("Source_Classification_Code.rds")
        
        ## Rename column EI.Sector for sqldf!
        colnames(SCC)[4]<-"EI_Sector"
        
        ## Select relevant rows
        SCC_subset<-sqldf("select SCC, EI_Sector from SCC where EI_Sector like '%Coal%' and EI_Sector like '%Comb%' ")
        
        ## Join NE to create subset
        NEI_subset <- sqldf("select NEI.* from NEI, SCC_subset where NEI.SCC = SCC_subset.SCC")
        
        ## Calculate relevant values
        NEI_group <- sqldf("select year, 
                    sum(Emissions) as Sum_Emissions
                    from NEI_subset 
                    group by year")
        
        
        
        ## open a graphics device
        png(filename = "plot4.png", 
            width = 480, 
            height = 480, 
            units = "px", 
            bg = "white" )
        
        
        ## Make a ggplot 
        print(
                ggplot(data=NEI_group, aes(x=factor(year), y=Sum_Emissions)) + 
                        geom_bar(fill = "blue", stat="identity") + 
                        xlab ("Year") +
                        ylab ("Total PM2.5 emitted (tons)") + 
                        ggtitle ("US PM2.5 Emissions 1999-2008 from Coal Combustion")
        )
        ## close the device...
        dev.off()
        
        ## ..and clean up
        rm(list=ls())
        
}