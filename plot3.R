
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
png(file = "plot3.png", width = 480, height = 480, units = "px")
plot(data$DateTime,data$Sub_metering_1,type="l",ylab="Energy sub metering",xlab="")
lines(data$DateTime,data$Sub_metering_2,col="red")
lines(data$DateTime,data$Sub_metering_3,col="blue")
legend("topright",col=c("black","red","blue"),lty=1,legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

dev.off()

