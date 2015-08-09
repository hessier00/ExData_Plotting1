## --> Read the dataset and perform default cleaning <-- ##

## Read the entire dataset into a data frame
power<-read.table("household_power_consumption.txt", header=TRUE, sep=";", na.strings='?')

## Convert the first column to correct date format
power[,1]<-as.Date(power[,1], "%d/%m/%Y")

## Subset down to just the dates 007-02-01 and 2007-02-02
power<-power[power$Date>="2007-02-01" & power$Date<="2007-02-02",]

## Concatenate the date and time into a single value
power$DateTime<-with(power, paste(power$Date,power$Time, sep=" "))

## Convert the separate Date and Time columns to a single POSIX datetime column
power$DateTime<-strptime(power$DateTime, format="%Y-%m-%d %H:%M:%S")

## Drop the now-unnecessary Date and Time columns
power<-power[,!(names(power) %in% c("Date","Time"))]


## --> Perform cleaning and plotting tasks specific to Plot 2 <-- ##

## Convert Global_active_power to a numeric value
power$Global_active_power<-as.numeric(power$Global_active_power)

## Create a PNG file to hold the graph
png(file="plot2.png")

## Draw and label the x/y plot
plot(power$DateTime, power$Global_active_power, xlab="", ylab="Global Active Power (kilowatts)", type="l")

## CLose the PNG file/graphics device
dev.off()
