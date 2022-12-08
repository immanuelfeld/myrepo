library(readxl)
library(tidyverse)
library(writexl)
library(stargazer)
library(sandwich)
library(lmtest)
library(haven)

# Set working directory
wd <- ("/Users/immanuelfeld/Documents/Uni/Warwick/Year_2/Dissertation")
setwd(wd)

# Create data path
data <- paste0(wd, "/Data")
output <- paste0(wd, "/Output")

# Load data
df1 <- read_dta(paste0(data, "/Inputs/Intermediate/deprivation_income_iv.dta"))

# Summary statistics
stats <- subset(df1, select = c(gp_distance, school_distance, population, room_cut, bed_1_cut, bed_2_cut, bed_3_cut, bed_4_cut,
                                avg_cut, mean_house_price))


stargazer(as.data.frame(stats), out = paste0(output, "/Tables/Tables/", "sum_stats.tex"), title = "Summary Statistics", 
          covariate.labels = c( "Distance to nearest GP", "Distance to nearest primary school", 
                               "Population", "Cut shared room (in %)", 
                               "Cut 1 bedroom (in %)", "Cut 2 bedroom (in %)",
                               "Cut 3 bedroom (in %)", "Cut 4 bedroom (in %)",
                               "Average cut (in %)", "House price"), 
          label = "tab:sumstats", style = "qje", notes.append = FALSE, notes.align = "l",
          notes = "\\parbox[t]{\\textwidth}{This table displays the descriptive statistics for all variables used in the empirical analysis of this paper.}")