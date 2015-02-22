## Exploratory Data Analysis: Course Project 2
## 2015-02-22 bankbintje
## Build and tested on 
# R version 3.1.2 
# R Studio Version 0.98.1062   
# Mac (x86_64-apple-darwin13.1.0)

plot6 <- function () {
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
                        
        ## Join NEI to create subset
        NEI_subset <- sqldf("select NEI.* from NEI, SCC_subset where NEI.SCC = SCC_subset.SCC")
        
        ## Calculate relevant values
        NEI_group <- sqldf("select year, 
                    sum(Emissions) as Sum_Emissions, 
                    case WHEN fips = '06037' THEN 'Los Angeles' ELSE 'Baltimore' END as 'County' 
                    from NEI_subset where fips  in ('24510', '06037')
                    group by year, County")
                        
        ## open a graphics device
        png(filename = "plot6.png", 
            width = 640, 
            height = 640, 
            units = "px", 
            bg = "white" )
                
        ## Make a ggplot and add a regression line
        print(
                
                ggplot(data=NEI_group, aes(group=1, x=factor(year), y=Sum_Emissions,fill=County)) + 
                        geom_bar(stat="identity")  + 
                        facet_wrap (~County, ncol=2, scales = "free") + 
                        stat_smooth(method="lm",se=FALSE) +
                        xlab ("Year") +
                        ylab ("Total PM2.5 emitted (tons)") + 
                        ggtitle ("Baltimore & LA County PM2.5 Emissions from Vehicles 1999-2008")
                
        )
        ## close the device...
        dev.off()
        
        ## ..and clean up
        rm(list=ls())
        
}