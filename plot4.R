## --> Read the dataset and perform default cleaning <-- ##

## Read the entire dataset into a data frame
power<-read.table("household_power_consumption.txt", header=TRUE, sep=";",na.strings='?')

## Convert the first column to correct date format
power[,1]<-as.Date(power[,1],"%d/%m/%Y")

## Subset down to just the dates 007-02-01 and 2007-02-02
power<-power[power$Date>="2007-02-01" & power$Date<="2007-02-02",]

## Concatenate the date and time into a single value
power$DateTime<-with(power, paste(power$Date,power$Time, sep=" "))

## Convert the separate Date and Time columns to a single POSIX datetime column
power$DateTime<-strptime(power$DateTime, format="%Y-%m-%d %H:%M:%S")

## Drop the now-unnecessary Date and Time columns
power<-power[,!(names(power) %in% c("Date","Time"))]


## --> Perform cleaning and plotting tasks <-- ##

## Convert sub-metering columns to numerical values
columns<-c(power$Global_active_power,
           power$Global_reactive_power,
           power$Voltage,
           power$Sub_metering_1,
           power$Sub_metering_2,
           power$Sub_metering_3)
for (column in columns) {
  column<-as.numeric(column)
}

## Create a PNG file to hold the graph
png(file="plot4.png")

## Set the number of columns and rows, using mfrow to draw left-to-right, then down to the next row
par(mfrow = c(2, 2))

## Draw and label the top-left plot
plot(power$DateTime, power$Global_active_power, xlab="", ylab="Global Active Power", type="l")

## Draw and label the top-right plot
plot(power$DateTime, power$Voltage, xlab="datetime", ylab="Voltage", type="l")

## Draw and label the bottom-left plot
## First, draw the plot framework and line for Sub_metering_1
plot(power$DateTime, power$Sub_metering_1, xlab="", ylab="Energy sub metering", type="l", col="black")
## Then, add the line for Sub_metering_2 in red
points(power$DateTime, power$Sub_metering_2, type="l", col="red")
## Next, add the line for Sub_metering_3 in blue
points(power$DateTime, power$Sub_metering_3, type="l", col="blue")
## Finally, add the legend
legendItems<-c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3")
legendColors<-c("black","red","blue")          
legend("topright", legendItems, col=legendColors, bty="n", lwd=2.5, cex=0.7)

## Draw and label the bottom-right plot
plot(power$DateTime, power$Global_reactive_power, xlab="datetime", ylab="Global_reactive_power", type="l")

## CLose the PNG file/graphics device
dev.off()
