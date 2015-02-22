## Exploratory Data Analysis: Course Project 2
## 2015-02-22 bankbintje
## Build and tested on 
# R version 3.1.2 
# R Studio Version 0.98.1062   
# Mac (x86_64-apple-darwin13.1.0)

plot5 <- function () {
        options(warn=-1)           
        # Clear all:
        rm(list=ls())        
        # Load packages                 
        library(sqldf)        
        library(ggplot2)        
        
        ## Load data
        NEI <- readRDS("summarySCC_PM25.rds")
        SCC <- readRDS("Source_Classification_Code.rds")
        
        ## Rename columns for sqldf!
        colnames(SCC)[3]<-"Short_Name"
        colnames(SCC)[4]<-"EI_Sector"
        colnames(SCC)[7]<-"SCC_Level_One"
        colnames(SCC)[8]<-"SCC_Level_Two"
        colnames(SCC)[9]<-"SCC_Level_Three"
        colnames(SCC)[10]<-"SCC_Level_Four"
                
        ## Select relevant rows
        SCC_subset<-sqldf("select SCC from SCC where
        UPPER(Short_Name) like '%VEHICLE%' or
        UPPER(EI_Sector) like '%VEHICLE%' or
        UPPER(SCC_Level_One) like '%VEHICLE%' or
        UPPER(SCC_Level_Two) like '%VEHICLE%' or
        UPPER(SCC_Level_Three) like '%VEHICLE%' or
        UPPER(SCC_Level_Four) like '%VEHICLE%' ")
                        
        ## Join NE to create subset
        NEI_subset <- sqldf("select NEI.* from NEI, SCC_subset where NEI.SCC = SCC_subset.SCC")
        
        ## Calculate relevant values
        NEI_group <- sqldf("select year, 
                    sum(Emissions) as Sum_Emissions
                    from NEI_subset where fips = 24510
                    group by year")
                        
        ## open a graphics device
        png(filename = "plot5.png", 
            width = 480, 
            height = 480, 
            units = "px", 
            bg = "white" )
                
        ## Make a ggplot 
        print(
                ggplot(data=NEI_group, aes(x=factor(year), y=Sum_Emissions)) + 
                        geom_bar(fill = "green", stat="identity") + 
                        xlab ("Year") +
                        ylab ("Total PM2.5 emitted (tons)") + 
                        ggtitle ("Baltimore PM2.5 Emissions 1999-2008 from Vehicles")
        )
        ## close the device...
        dev.off()
        
        ## ..and clean up
        rm(list=ls())
        
}