#### Packages ##################################################################
library(splitstackshape) 
library(readr)
library(tidyverse)
library(data.table)

### Paths ######################################################################
path = "/Users/immanuelfeld/Dropbox/Research/Projects/Public_Amenities"
data = paste0(path, "/Data")
output = paste0(path, "/Outputs")

#### Load Data #################################################################
# List all CSV files from folder
files = list.files(path = paste0(data, "/Possible_data/Libraries US/library_level"), pattern = ".csv", full.names = TRUE, recursive = FALSE)

# Get names of the files
names = as.data.frame(files)

names = names %>%
  cSplit("files", "library_level/") %>%
  cSplit("files_2", ".csv")

names[, files_1 := NULL]

# Extract numbers from strings
names[, numbers := parse_number(files_2_1)]

# Change to full years
names[nchar(numbers) == 1, numbers := paste0("200", numbers)]
names[nchar(numbers) == 2 & numbers < 21, numbers := paste0("20", numbers)]
names[nchar(numbers) == 2 & numbers > 90, numbers := paste0("19", numbers)]

for (i in 1:length(files)) {
  
  # Read data 
  lib = read_csv(files[i])
  
  # Variable names to lowercase
  names(lib) = tolower(names(lib))
  
  # Drop the Imputation flags
  lib = lib %>%
    select(-contains("imp"))
  
  # Add year to every variable for reshaping
  lib_dt = as.data.table(lib) # convert to data table
  colnames = colnames(lib_dt)
  remove_list = c("stabr", "fscskey","libid", "libname", "address", "city", "cnty", 
                  "zip", "zip4", "c_relatn", "c_legbas", "c_admin", "c_fscs")
  colnames_true = setdiff(colnames, remove_list)
  setnames(lib_dt, old = colnames_true, new = paste0(colnames_true, names$numbers[i]))
  
  # Export to CSV
  write.csv(lib_dt, file = paste0(data, "/Possible_data/Libraries US/library_level/outputs/",
                               names$numbers[i], ".csv"))
  
}

### Merge datasets of libraries ################################################




################################################################################
# Here we test stuff
lib = read_csv(paste0(data, "/Possible_data/Libraries US/library_level/PUPLDF98.csv"))

# Variable names to lowercase
names(lib) = tolower(names(lib))

# Drop the Imputation flags
lib = lib %>%
  select(-contains("imp"))

# Add year to every variable for reshaping
lib_dt = as.data.table(lib)
colnames = colnames(lib_dt)
remove_list = c("stabr", "fscskey","libid", "libname", "address", "city", "cnty", 
                "zip", "zip4", "c_relatn", "c_legbas", "c_admin", "c_fscs")
colnames_true = setdiff(colnames, remove_list)

setnames(lib_dt, old = colnames, new = paste0(colnames, names$numbers[12]))
