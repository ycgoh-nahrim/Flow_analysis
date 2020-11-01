# Automation for rmarkdown

# contains a loop that iteratively calls an Rmarkdown file (i.e. File 2)

# load packages
library(knitr)
library(markdown)
library(rmarkdown)
library(tidyverse)

# database of station number and name
stn_path <- "C:/Users/user/Documents/GYC/FDC/Data/JPS_WL_PM.csv"
stn_db <- read.csv(file = stn_path,
                    header = TRUE, sep=",") #depends on working dir

#select stations by state
state_sel <- "Wilayah Persekutuan"


#SELECT STATION LIST BY STATE
stn_sel <- stn_db %>%
  filter(STATE == state_sel) %>% #check field name
  arrange(STATION_NO)


#test
#stn_sel2 <- stn_sel[1:3,]


# list of stations with data
stn_list <- read.csv(file = "C:/Users/user/Documents/GYC/FDC/Data/stn_list.csv",
                   header = TRUE, sep=",")


# join list with station data list

## select data
stn_sel_data <- stn_sel %>%
  inner_join(stn_list, by = c("STATION_NO" = "Stn_no")) 


# for each station in the data create a report
# these reports are saved in output_dir with the name specified by output_file
for (i in unique(stn_sel_data$STATION_NO)){
  
  # filename
  Station_No <- i
  Station_Name <- stn_sel_data[stn_sel_data$STATION_NO == Station_No, 2]
  
  
  # Set up parameters to pass to Rmd document
  params_stn <- list(Station_No = Station_No,
                     Station_Name = Station_Name,
                     SF_filename = NULL,
                     Water_year_month = 1,
                     Percentile_Q = 0,
                     Q_percentile = 0,
                     Min_cnt_yr = 347,
                     Data_source = "JPS"
                     )
  
  rmarkdown::render('flow_analysis_1.0.0.4.Rmd',  # rmarkdown file
                    output_file =  paste0("SF", Station_No, "_",Station_Name,
                                          "_flow_analysis.html"), 
                    output_dir = paste0("SF", Station_No, "_", Station_Name, "/"),
                    params = params_stn
                    )
}
