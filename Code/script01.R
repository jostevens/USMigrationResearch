# Libraries
library("foreign")


#Data

#Inflows
irs09_10in <- read.csv("http://www.irs.gov/pub/irs-soi/countyinflow0910.csv")
irs08_09in <- read.csv("http://www.irs.gov/pub/irs-soi/countyinflow0809.csv")
irs07_08in <- read.csv("http://www.irs.gov/pub/irs-soi/countyinflow0708.csv")
irs06_07in <- read.csv("http://www.irs.gov/pub/irs-soi/countyinflow0607.csv")
irs05_06in <- read.csv("http://www.irs.gov/pub/irs-soi/countyinflow0506.csv")
irs04_05in <- read.csv("http://www.irs.gov/pub/irs-soi/countyinflow0405.csv")

#Outflows
irs09_10out <- read.csv("http://www.irs.gov/pub/irs-soi/countyoutflow0910.csv")
irs08_09out <- read.csv("http://www.irs.gov/pub/irs-soi/countyoutflow0809.csv")
irs07_08out <- read.csv("http://www.irs.gov/pub/irs-soi/countyoutflow0708.csv")
irs06_07out <- read.csv("http://www.irs.gov/pub/irs-soi/countyoutflow0607.csv")
irs05_06out <- read.csv("http://www.irs.gov/pub/irs-soi/countyoutflow0506.csv")
irs04_05out <- read.csv("http://www.irs.gov/pub/irs-soi/countyoutflow0405.csv")

# Merge the data frames - only taking records that match both origin and destination
out <- merge(irs09_10out, irs08_09out, by=c("State_Code_Dest", "County_Code_Dest",
                                            "State_Code_Origin", "County_Code_Origin"))

# Need to melt the data - colapse it into the total inflows/outflows (by type) for each area and not look at the specific OD pairs yet

# Create new combined O or D code by concatenating state and county codes
concat  <- f{
  if State_Code_Origin < 10 (c"0", State_Code_Origin, County_Code_Origin)
  }

