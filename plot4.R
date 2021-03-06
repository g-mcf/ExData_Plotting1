#####################################################
# plot4.R
#
# Exploratory Data Analysis
# part of the Data Science Specialization
# from John Hopkins University on Coursera
#
# This script reproduces plot 4 of course project 1
#
#####################################################

# Load the required resources

library("data.table")

# Set the working directory.
# Read in the required data file.  This code checks that the unzipped text file is 
# already in the working directory, which is expected.
# Note that the fread command includes a colClasses 
# call to suppress warnings due to bumping of the column classes on reading the missing
# data argument "?".

setwd("~/Documents/Coursera/4_Exploratory Data Analysis/") # or your equivalent directory

if (!file.exists("household_power_consumption.txt")) {
    stop("I was expecting the HPC dataset to reside in your
         working directory")
} else {
    hpc <- fread("household_power_consumption.txt", sep = ";", 
                 colClasses = "character", na.strings = "?")
}

# Make the column names conform to R standards. I use those outlined in 
# Advanced R by Hadley Wickham at http://adv-r.had.co.nz/Style.html, which advises
# the following...
# Variable and function names should be lowercase. Use an underscore (_) to 
# separate words within a name.

setnames(hpc, tolower(colnames(hpc)))

# Key the data table on the date column

setkey(hpc, date)

# Subset the data table on the dates of interest and remove the no longer needed
# original data file to free up RAM

hpc_sub <- hpc[c("1/2/2007", "2/2/2007")]
rm(hpc)

# Add a column that merges and reclasses the date and time columns

hpc_plot <- hpc_sub[, date_time := as.POSIXct(paste(date, time), 
                                              format = "%d/%m/%Y %H:%M:%S")]
               
# Key the data table on the new date-time column

setkey(hpc_plot, date_time)

# remove unused objects

rm(hpc_sub)

# Construct the plot and write it to a png file

png( file = "plot4.png", height = 480, width = 480)

par(mfcol = c(2, 2), bg = "white",cex.axis = 0.8, cex.lab = 0.8, cex.main = 0.9)
hpc_plot[, plot(date_time, as.numeric(global_active_power),
                type = "l", xlab = "",
                ylab = "Global Active Power (kilowatts)")]

hpc_plot[, plot(date_time, sub_metering_1,type = "l",
                xlab = "", ylab = "Energy sub metering")]
hpc_plot[, lines(date_time, sub_metering_2, col = "red")]
hpc_plot[, lines(date_time, sub_metering_3, col = "blue")]


legend_names <- colnames(hpc_plot[, grep("sub", colnames(hpc_plot)), with = FALSE])
legend("topright", lty = "solid", col = c("black", "red", "blue"),
       legend = legend_names, cex = 0.8, bty ="n")      
    
hpc_plot[, plot(date_time, voltage, type = "l",
                    xlab = "datetime", ylab = "Voltage")]
    
hpc_plot[, plot(date_time, global_reactive_power, type = "l",
                    xlab ="datetime", ylab = "Global_reactive_power")]       
dev.off()

# remove unused objects

rm(legend_names)

# fyi...for fun I analyzed the speed of this code; it is fast due to
# the use of data.table
#
#  > ss <- system.time(source("~/Documents/Coursera/4_Exploratory Data Analysis/plot4.R"))
#  > ss
#  user  system elapsed 
#  1.84    0.10    1.94 
