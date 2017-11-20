
# check packages
if (!"sqldf" %in% installed.packages()){
  install.packages("sqldf")
}

library(sqldf)

url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
file <- "./data.zip"

# Get data "Electric power consumption" if not exists
if(!file.exists("./household_power_consumption.txt")){
  download.file(url,destfile = file)  
  unzip(file)
  file.remove(file)
}

# read data only for 2007-02-01 and 2007-02-02
data <- read.csv.sql("household_power_consumption.txt","select * from file where Date = '1/2/2007' or Date = '2/2/2007' ",sep=";")

# replace missing values ? with NA
data[data == "?"] <- NA

# convert to Date
data$DateTime <- strptime(paste(data$Date, data$Time),'%d/%m/%Y %H:%M:%S')

# convert measurement to numeric 
data$Global_active_power <- as.numeric(data$Global_active_power)

# plot global active power
png(file = "plot1.png", width = 480, height = 480, units = "px")
hist(data$Global_active_power,
     col = "red",
     main = "Global Active Power",
     xlab = "Global Active Power (kilowatts)")
dev.off()

