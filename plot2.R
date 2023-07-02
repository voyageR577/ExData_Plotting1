# STEP 1 read the data

# download the dataset if needed
if (!file.exists("household_power_consumption.txt")) {
    url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
    download.file(url, destfile = "exdata_data_household_power_consumption.zip", method = "curl")
    unzip("exdata_data_household_power_consumption.zip")
    message("makes sure that the data file is in your working directory while running the script")
}
# install pacakges needed if not yet
packages <- c('data.table','tidyverse')
install.packages(setdiff(packages, rownames(installed.packages())))

# load pacakges needed for this script
library(data.table)
library(tidyverse)

# read the data into R and clean it
file <- "household_power_consumption.txt"
DT<-fread(file)
DT <- DT %>%
    filter(Date == "1/2/2007" | Date == "2/2/2007") %>%
    as_tibble

DT <- DT %>%
    unite(Date_time,Date,Time, sep = " ")

DT$Date_time <- strptime(DT$Date_time, format = "%d/%m/%Y %H:%M:%S")

# change the class of column 2 to 8 to numeric
DT[,2:8] <- 
    DT %>%
    select(2:8) %>%
    type_convert("nnnnnnn")

# STEP 2 plot

par(mfrow=c(1,1))
plot(DT$Date_time,DT$Global_active_power,
     type = "l",
     xlab = "",
     ylab = "Global Active Power (kilowatts)")
dev.copy(png,"plot2.png")
dev.off()