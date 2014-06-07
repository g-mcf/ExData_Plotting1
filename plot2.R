#####################################################
# plot2.R
#
# Exploratory Data Analysis
# part of the Data Science Specialization
# from John Hopkins University on Coursera
#
# This script reproduces plot 2 of course project 1
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

hpc_sub <- hpc[date == "1/2/2007" | date == "2/2/2007"]
rm(hpc)

# Create a data table with new column that merges the date and time columns and
# reclasses them

hpc_plot <- hpc_sub[, date_time := as.POSIXct(paste(date, time), 
                                              format = "%d/%m/%Y %H:%M:%S")]

# Key the data table on the new date-time column
setkey(hpc_plot, date_time)

# remove unused objects
rm(hpc_sub)

# Construct the plot and write it to a png file

png( file = "plot2.png", height = 480, width = 480)

par(bg = "white",cex.axis = 0.8, cex.lab = 0.8, cex.main = 0.9)
hpc_plot[, plot(date_time, as.numeric(global_active_power),
                         type = "l", xlab = "",
                         ylab = "Global Active Power (kilowatts)")]

dev.off()

# That's it!