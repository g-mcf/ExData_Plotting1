################################################
# plot1.R
#
# This script reproduces plot 1 of the course
# project 1
#
#

# load required resources
library("data.table")

# set the working directory
setwd("~/Documents/Coursera/4_Exploratory Data Analysis/")

# Read in the required data file.  This code assumes the file is already in
# the working directory.
# Note that the fread command includes a colClasses call to suppress warnings
# due to bumping of the column classes on reading the missing data argument "?"
hpc <- fread("household_power_consumption.txt", sep = ";", nrows = -1,
             colClasses = "character")

# make the column names conform to R standards. I use those outlined in 
# Advanced R by Hadley Wickham at http://adv-r.had.co.nz/Style.html
setnames(hpc, tolower(colnames(hpc)))

# Key the data table on the date and time columns
setkey(hpc, date, time)

# Subset the data table on the dates of interest and remove the original
# data file to free up RAM
hpc_plot <- hpc[date == "1/2/2007" | date == "2/2/2007"]
rm(hpc)

# Construct the plot and write it to a png file
par(bg = "white",cex.axis = 0.8, cex.lab = 0.8, cex.main = 0.9)
plot1 <- hpc_plot[ , hist(as.numeric(global_active_power),
                          main ="Global Active Power",
                          xlab = "Global Active Power (kilowatts)",
                          col = "red",
                          border = "black")]

dev.copy(png, file = "plot1.png")
dev.off()

# That's it!



 




