# Clear all:
dev.off()
rm(list=ls())



setwd("/Users/makispoulianidis/Business Intelligence/GitHub/ExData_Plotting2")

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

dplyr::tbl_df(NEI)
dplyr::tbl_df(SCC)

dplyr::inner_join(NEI,SCC, by="SCC")


## convert year to numeric
NEI_subset$year <- as.numeric(NEI_subset$year)




png(filename = "plot_test.png", 
    width = 480, 
    height = 480, 
    units = "px", 
    bg = "white" )

> x<-ggplot(data=NEI_subset, aes(x=year, y=Sum_Emissions,fill=type)) + geom_bar(colour="black", stat="identity")

x<-ggplot(data=NEI_subset, aes(x=factor(year), y=sum(Emissions),fill=type)) + geom_bar(stat="identity")

x<-ggplot(data=NEI_subset, aes(x=factor(year), y=sum(Emissions),fill=type)) 
> x + geom_bar(stat="identity") + facet_wrap(type~year)

Beste:
x<-ggplot(data=NEI_subset, aes(x=factor(year), y=sum(Emissions),fill=type)) 
x + geom_bar(stat="identity") + facet_grid (.~type)


x + geom_bar(stat="identity") + facet_grid (.~type) + scale_fill_brewer(palette="Set1")


x<-ggplot(data=NEI_subset, aes(x=factor(year), y=Sum_Emissions,fill=type)) 




ggplot(data=NEI_subset, aes(x=factor(year), y=Sum_Emissions,fill=type)) +
        geom_bar(stat="identity") +
        facet_wrap (~type, ncol=2, scales = "free") +
        scale_fill_brewer(palette="Set1") +
        xlab ("Year") +
        ylab ("Total PM2.5 emitted (tons)") +
        ggtitle ("Total PM2.5 Emissions 1999-2008 in Baltimore City per Type")



CoalData            <- NEIData[NEIData$SCC %in% CoalComb$SCC,]
