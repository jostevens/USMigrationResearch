#Data Munging

    # Data Sources:
      # LEHD : http://lehd.did.census.gov/onthemap/LODES5/
      # 2000 Block Shape Files: ftp://ftp2.census.gov/geo/tiger/TIGER2010/TABBLOCK/2000  -  The block level data is aggrgated to both the county and state level - states have a 2 digit code and counties have a five digit code
            # the LODE6 has the data in 2010 census geography, but I grabbed LODE5 which uses 2000

    # I used 7-zip to uncompress the files and suction.exe to move directories
    # I also renamed the shp files with postal codes instead of the 2 digit codes


  #Libraries
library("plyr")
library("foreign")

    # These first few states have a leading zero in the block id an will not join 
    # This first loop writes out the files as csv file  ('cause I don't feel like learning regex) When read as a csv the FIPS identifiers change their data type, dropping the leading zeros
          gshp1 <- c("ak", "al", "ar", "az", "ca", "co", "ct") 
   #         for(k in gshp1){ #loop through states
              state <- k
              path03 <- c("C:/Users/School/Documents/DataSets/census/2000/tl_2010_", state, "_tabblock00.dbf")
              pathg1 <- paste(path03, collapse = "")
              geo1 <- read.dbf(pathg1)
              opath03 <- c("L:/IRSmig/Tabular data/01fixit_", state, ".csv")
              opath04 <- paste(opath03, collapse = "")
              write.csv(geo1, file=opath04, row.names = TRUE) # write out county level data as csv
            }

     # this loop will read in the modified csv files and replace the original dbf files
  #        for(k in gshp1){ #loop through states
            state <- k
            opath03 <- c("L:/IRSmig/Tabular data/01fixit_", state, ".csv")
            opath04 <- paste(opath03, collapse = "")
            path03 <- c("C:/Users/School/Documents/DataSets/census/2000/tl_2010_", state, "_tabblock00.dbf")
            pathg1 <- paste(path03, collapse = "")
            geo <- read.csv(opath04)
             geo$geo <- as.factor(geo$BLKIDFP00) # These two steps are needed to transform the BLKID field back into something that will work with the rest of the scrips after the csv conversion
             geo$BLKIDFP00  <- geo$geo
            write.dbf(geo, file=pathg1, factor2char = TRUE) 
          }

  # List for possible loop   - The file name changes from rac to wac (residential or workplace area characteristics). Also the geo code changes from h to w 
rw <- c("rac", "wac")


    # Need to combine all of the block shp files by state an rename them
  #List of states to loop through
gshp <- c("ak", "ar","az", "al",  "ca", "co", "ct", "de","fl","ga", "hi", "ia", "id", "in",
          "il", "ks", "ky", "la", "ma", "md", "me", "mi", "mn","mo", "ms", "mt", "nc", "nd", "ne",
          "nh", "nj", "nm", "nv", "ny", "oh", "ok", "or", "pa", "ri", "sd", "tn", "tx", "ut",
          "va", "vt", "wa", "wi", "wv", "wy") # "dc",  

  
for(j in gshp){ #loop through states
  state <- j
  indx <- c(2, 3, 4, 5, 6, 7, 8, 9) # for loop through years
  path01 <- c("C:/Users/School/Documents/DataSets/census/2000/tl_2010_", state, "_tabblock00.dbf")
  pathg <- paste(path01, collapse = "")
  geo <- read.dbf(pathg)

  for (i in indx){ # begin loop through years
    path <- c("C:/Users/School/Documents/DataSets/LEHD/LODE5/", state, "/", state, "_rac_S000_JT00_200", i, " (1).csv")
    pathd <- paste(path, collapse = "")
  
    # create data frame for each year
    if(i==2) { rac<- read.csv(pathd)
               rac$year <- 2002 # add year column
               rac$geo <- as.factor(rac$w_geocode)
               t02 <- merge(geo, rac, by.x = "BLKIDFP00", by.y = "geo", sort=F)
               r02 <- ddply(t02, .(COUNTYFP00), function(df) c(sum(df$C000), sum(df$CA01), sum(df$CA02), sum(df$CA03), sum(df$CE01), sum(df$CE02), sum(df$CE03),
                                                               sum(df$CR01), sum(df$CR02), sum(df$CR03), sum(df$CR04), sum(df$CR05), sum(df$CR06), sum(df$CR07),
                                                               sum(df$CT01), sum(df$CT02), sum(df$CT03), sum(df$CT04), mean(df$year)))} # aggrgate to the county level
    if(i==3) {rac <- read.csv(pathd)
              rac$year <- 2003
              rac$geo <- as.factor(rac$w_geocode)
              t02 <- merge(geo, rac, by.x = "BLKIDFP00", by.y = "geo", sort=F) 
              r03 <- ddply(t02, .(COUNTYFP00), function(df) c(sum(df$C000), sum(df$CA01), sum(df$CA02), sum(df$CA03), sum(df$CE01), sum(df$CE02), sum(df$CE03),
                                                              sum(df$CR01), sum(df$CR02), sum(df$CR03), sum(df$CR04), sum(df$CR05), sum(df$CR06), sum(df$CR07),
                                                              sum(df$CT01), sum(df$CT02), sum(df$CT03), sum(df$CT04), mean(df$year)))}
    if(i==4) {rac <- read.csv(pathd)
              rac$year <- 2004
              rac$geo <- as.factor(rac$w_geocode)
              t02 <- merge(geo, rac, by.x = "BLKIDFP00", by.y = "geo", sort=F)
              r04 <- ddply(t02, .(COUNTYFP00), function(df) c(sum(df$C000), sum(df$CA01), sum(df$CA02), sum(df$CA03), sum(df$CE01), sum(df$CE02), sum(df$CE03),
                                                              sum(df$CR01), sum(df$CR02), sum(df$CR03), sum(df$CR04), sum(df$CR05), sum(df$CR06), sum(df$CR07),
                                                              sum(df$CT01), sum(df$CT02), sum(df$CT03), sum(df$CT04), mean(df$year)))}
    if(i==5) {rac <- read.csv(pathd)
              rac$year <- 2005
              rac$geo <- as.factor(rac$w_geocode)
              t02 <- merge(geo, rac, by.x = "BLKIDFP00", by.y = "geo", sort=F) 
              r05 <- ddply(t02, .(COUNTYFP00), function(df) c(sum(df$C000), sum(df$CA01), sum(df$CA02), sum(df$CA03), sum(df$CE01), sum(df$CE02), sum(df$CE03),
                                                              sum(df$CR01), sum(df$CR02), sum(df$CR03), sum(df$CR04), sum(df$CR05), sum(df$CR06), sum(df$CR07),
                                                              sum(df$CT01), sum(df$CT02), sum(df$CT03), sum(df$CT04), mean(df$year)))}
    if(i==6) {rac <- read.csv(pathd)
              rac$year <- 2006
              rac$geo <- as.factor(rac$w_geocode)
              t02 <- merge(geo, rac, by.x = "BLKIDFP00", by.y = "geo", sort=F)
              r06 <- ddply(t02, .(COUNTYFP00), function(df) c(sum(df$C000), sum(df$CA01), sum(df$CA02), sum(df$CA03), sum(df$CE01), sum(df$CE02), sum(df$CE03),
                                                              sum(df$CR01), sum(df$CR02), sum(df$CR03), sum(df$CR04), sum(df$CR05), sum(df$CR06), sum(df$CR07),
                                                              sum(df$CT01), sum(df$CT02), sum(df$CT03), sum(df$CT04), mean(df$year)))}
    if(i==7) {rac <- read.csv(pathd)
              rac$year <- 2007
              rac$geo <- as.factor(rac$w_geocode)
              t02 <- merge(geo, rac, by.x = "BLKIDFP00", by.y = "geo", sort=F)
              r07 <- ddply(t02, .(COUNTYFP00), function(df) c(sum(df$C000), sum(df$CA01), sum(df$CA02), sum(df$CA03), sum(df$CE01), sum(df$CE02), sum(df$CE03),
                                                              sum(df$CR01), sum(df$CR02), sum(df$CR03), sum(df$CR04), sum(df$CR05), sum(df$CR06), sum(df$CR07),
                                                              sum(df$CT01), sum(df$CT02), sum(df$CT03), sum(df$CT04), mean(df$year)))}
    if(i==8) {rac <- read.csv(pathd)
              rac$year <- 2008
              rac$geo <- as.factor(rac$w_geocode)
              t02 <- merge(geo, rac, by.x = "BLKIDFP00", by.y = "geo", sort=F)
              r08 <- ddply(t02, .(COUNTYFP00), function(df) c(sum(df$C000), sum(df$CA01), sum(df$CA02), sum(df$CA03), sum(df$CE01), sum(df$CE02), sum(df$CE03),
                                                              sum(df$CR01), sum(df$CR02), sum(df$CR03), sum(df$CR04), sum(df$CR05), sum(df$CR06), sum(df$CR07),
                                                              sum(df$CT01), sum(df$CT02), sum(df$CT03), sum(df$CT04), mean(df$year)))}
    if(i==9) {rac <- read.csv(pathd)
              rac$year <- 2009
              rac$geo <- as.factor(rac$w_geocode)
              t02 <- merge(geo, rac, by.x = "BLKIDFP00", by.y = "geo", sort=F)
              r09 <- ddply(t02, .(COUNTYFP00), function(df) c(sum(df$C000), sum(df$CA01), sum(df$CA02), sum(df$CA03), sum(df$CE01), sum(df$CE02), sum(df$CE03),
                                                              sum(df$CR01), sum(df$CR02), sum(df$CR03), sum(df$CR04), sum(df$CR05), sum(df$CR06), sum(df$CR07),
                                                              sum(df$CT01), sum(df$CT02), sum(df$CT03), sum(df$CT04), mean(df$year)))}
  } 
  state.all  <- rbind(r02, r03, r04, r05, r06, r07, r08, r09)# bind all year files into general state file
  state.all$state  <- toupper(state)
  
  opath01 <- c("L:/IRSmig/Tabular data/rac_all.csv")
  opath02 <- paste(opath01, collapse = "")
  write.csv(state.all, file=opath02, append = TRUE, row.names = TRUE) # write out county level data as csv
}


# Label Names
# C000 total number of jobs
# CA01 jobs for workers <=29years
# CA02 jobs for workers 30-54years
# CA03 jobs for workers >=55years
# 
# CE01 jobs with earnings <=1250/month
# CE02 jobs with earnings 1250-3333/month
# CE03 jobs with earnings >=3333/month
# 
# CR01 jobs for worker with race White Alone
# CR02 jobs for worker with race black Alone
# CR03 jobs for worker with race AIAN Alone
# CR04 jobs for worker with race Asian Alone
# CR05 jobs for worker with race 2+ Alone
# CR06 jobs for worker with race Not Latino Alone
# CR07 jobs for worker with race Latino Alone
# 
# CT01 jobs for workers with ed >HS
# CT02 jobs for workers with ed =HS
# CT03 jobs for workers with ed =SC/AS
# CT04 jobs for workers with ed BS or higher

#Data - Pull raw data from IRS website
#-----
#Inflows
irs09_10in <- read.csv("http://www.irs.gov/pub/irs-soi/countyinflow0910.csv")
  irs09_10in$year <- 2009 # Add year data
#Concatenate the state and county numbers
  irs09_10in$codeD <- paste(irs09_10in$State_Code_Dest, irs09_10in$County_Code_Dest, sep="_") 
  irs09_10in$codeO <- paste(irs09_10in$State_Code_Origin, irs09_10in$County_Code_Origin, sep="_")

irs08_09in <- read.csv("http://www.irs.gov/pub/irs-soi/countyinflow0809.csv")
  irs08_09in$year <- 2008
irs08_09in$codeD <- paste(irs08_09in$State_Code_Dest, irs08_09in$County_Code_Dest, sep="_")
irs08_09in$codeO <- paste(irs08_09in$State_Code_Origin, irs08_09in$County_Code_Origin, sep="_")

irs07_08in <- read.csv("http://www.irs.gov/pub/irs-soi/countyinflow0708.csv")
  irs07_08in$year <- 2007
irs07_08in$codeD <- paste(irs07_08in$State_Code_Dest, irs07_08in$County_Code_Dest, sep="_")
irs07_08in$codeO <- paste(irs07_08in$State_Code_Origin, irs07_08in$County_Code_Origin, sep="_")

irs06_07in <- read.csv("http://www.irs.gov/pub/irs-soi/countyinflow0607.csv")
  irs06_07in$year <- 2006
irs06_07in$codeD <- paste(irs06_07in$State_Code_Dest, irs06_07in$County_Code_Dest, sep="_")
irs06_07in$codeO <- paste(irs06_07in$State_Code_Origin, irs06_07in$County_Code_Origin, sep="_")

irs05_06in <- read.csv("http://www.irs.gov/pub/irs-soi/countyinflow0506.csv")
  irs05_06in$year <- 2005
irs05_06in$codeD <- paste(irs05_06in$State_Code_Dest, irs05_06in$County_Code_Dest, sep="_")
irs05_06in$codeO <- paste(irs05_06in$State_Code_Origin, irs05_06in$County_Code_Origin, sep="_")

irs04_05in <- read.csv("http://www.irs.gov/pub/irs-soi/countyinflow0405.csv")
  irs04_05in$year <- 2004
irs04_05in$codeD <- paste(irs04_05in$State_Code_Dest, irs04_05in$County_Code_Dest, sep="_")
irs04_05in$codeO <- paste(irs04_05in$State_Code_Origin, irs04_05in$County_Code_Origin, sep="_")

#-----
#Outflows
irs09_10out <- read.csv("http://www.irs.gov/pub/irs-soi/countyoutflow0910.csv")
  irs09_10out$year <- 2009
irs08_09out <- read.csv("http://www.irs.gov/pub/irs-soi/countyoutflow0809.csv")
  irs08_09out$year <- 2008
irs07_08out <- read.csv("http://www.irs.gov/pub/irs-soi/countyoutflow0708.csv")
  irs07_08out$year <- 2007
irs06_07out <- read.csv("http://www.irs.gov/pub/irs-soi/countyoutflow0607.csv")
  irs06_07out$year <- 2006
irs05_06out <- read.csv("http://www.irs.gov/pub/irs-soi/countyoutflow0506.csv")
  irs05_06out$year <- 2005
irs04_05out <- read.csv("http://www.irs.gov/pub/irs-soi/countyoutflow0405.csv")
  irs04_05out$year <- 2004

#-------
#Other IRS County Data
county2009 <- read.csv("http://www.irs.gov/pub/irs-soi/09incicsv.csv")
county2008 <- read.csv("http://www.irs.gov/pub/irs-soi/08incicsv.csv")
county2007 <- read.csv("http://www.irs.gov/pub/irs-soi/countyincome07.csv")
county2006 <- read.csv("http://www.irs.gov/pub/irs-soi/countyincome06.csv")
county2005 <- read.csv("http://www.irs.gov/pub/irs-soi/countyincome05.csv")
county2004 <- read.csv("http://www.irs.gov/pub/irs-soi/countyincome04.csv")


county2004$code <- paste(county2004$State_Code, county2004$County_Code, sep="_")
county2005$code <- paste(county2005$State_Code, county2005$County_Code, sep="_")
county2006$code <- paste(county2006$State_Code, county2006$County_Code, sep="_")
county2007$code <- paste(county2007$State_Code, county2007$County_Code, sep="_")
county2008$code <- paste(county2008$State_Code, county2008$County_Code, sep="_")
county2009$code <- paste(county2009$State_Code, county2009$County_Code, sep="_")

# Aggregate By Destination and Create Rankings for number of connections and total migrants
library(plyr)
#-------2004----------
  #Remove state and nation rows
temp1 <- irs04_05in[which (irs04_05in$State_Code_Origin!=96), ]
temp2 <- temp1[which (temp1$State_Code_Origin!=97), ]
temp3 <- temp2[which (temp2$County_Code_Origin!=0), ]
temp4 <- temp3[which (temp3$codeD != temp3$codeO),]

M2004 <- ddply(temp4, .(codeD), function(df) c(sum(df$Return_Num), sum(df$Exmpt_Num),
                                              length(df$Return_Num), sum(df$Aggr_AGI), mean(df$year)))
M2004$Tmig <- M2004$V1 + M2004$V2 #Create Total Migrants Column
M2004.01 <- M2004[order(-M2004$Tmig),]
M2004.01$Mrank <- seq(1:2966) # Create Ranking based on Number of Migrants
M2004.02 <- M2004.01[order(-M2004.01$V3),] 
M2004.02$Crank <- seq(1:2966) # Create Ranking based on number of connections

#-------2005----------
#Remove state and nation rows
temp1 <- irs05_06in[which (irs06_07in$State_Code_Origin!=96), ]
temp2 <- temp1[which (temp1$State_Code_Origin!=97), ]
temp3 <- temp2[which (temp2$County_Code_Origin!=0), ]
temp4 <- temp3[which (temp3$codeD != temp3$codeO),]

M2005 <- ddply(temp4, .(codeD), function(df) c(sum(df$Return_Num), sum(df$Exmpt_Num),
                                               length(df$Return_Num), sum(df$Aggr_AGI), mean(df$year)))
M2005$Tmig <- M2005$V1 + M2005$V2 #Create Total Migrants Column
M2005.01 <- M2005[order(-M2005$Tmig),]
M2005.01$Mrank <- seq(1:2912) # Create Ranking based on Number of Migrants
M2005.02 <- M2005.01[order(-M2005.01$V3),] 
M2005.02$Crank <- seq(1:2912) # Create Ranking based on number of connections

#-------2006----------
#Remove state and nation rows
temp1 <- irs06_07in[which (irs06_07in$State_Code_Origin!=96), ]
temp2 <- temp1[which (temp1$State_Code_Origin!=97), ]
temp3 <- temp2[which (temp2$County_Code_Origin!=0), ]
temp4 <- temp3[which (temp3$codeD != temp3$codeO),]

M2006 <- ddply(temp4, .(codeD), function(df) c(sum(df$Return_Num), sum(df$Exmpt_Num),
                                               length(df$Return_Num), sum(df$Aggr_AGI), mean(df$year)))
M2006$Tmig <- M2006$V1 + M2006$V2 #Create Total Migrants Column
M2006.01 <- M2006[order(-M2006$Tmig),]
M2006.01$Mrank <- seq(1:2964) # Create Ranking based on Number of Migrants
M2006.02 <- M2006.01[order(-M2006.01$V3),] 
M2006.02$Crank <- seq(1:2964) # Create Ranking based on number of connections

#-------2007----------
#Remove state and nation rows
temp1 <- irs07_08in[which (irs06_07in$State_Code_Origin!=96), ]
temp2 <- temp1[which (temp1$State_Code_Origin!=97), ]
temp3 <- temp2[which (temp2$County_Code_Origin!=0), ]
temp4 <- temp3[which (temp3$codeD != temp3$codeO),]

M2007 <- ddply(temp4, .(codeD), function(df) c(sum(df$Return_Num), sum(df$Exmpt_Num),
                                               length(df$Return_Num), sum(df$Aggr_AGI), mean(df$year)))
M2007$Tmig <- M2007$V1 + M2007$V2 #Create Total Migrants Column
M2007.01 <- M2007[order(-M2007$Tmig),]
M2007.01$Mrank <- seq(1:2923) # Create Ranking based on Number of Migrants
M2007.02 <- M2007.01[order(-M2007.01$V3),] 
M2007.02$Crank <- seq(1:2923) # Create Ranking based on number of connections

#-------2008----------
#Remove state and nation rows
temp1 <- irs08_09in[which (irs06_07in$State_Code_Origin!=96), ]
temp2 <- temp1[which (temp1$State_Code_Origin!=97), ]
temp3 <- temp2[which (temp2$County_Code_Origin!=0), ]
temp4 <- temp3[which (temp3$codeD != temp3$codeO),]

M2008 <- ddply(temp4, .(codeD), function(df) c(sum(df$Return_Num), sum(df$Exmpt_Num),
                                               length(df$Return_Num), sum(df$Aggr_AGI), mean(df$year)))
M2008$Tmig <- M2008$V1 + M2008$V2 #Create Total Migrants Column
M2008.01 <- M2008[order(-M2008$Tmig),]
M2008.01$Mrank <- seq(1:2978) # Create Ranking based on Number of Migrants
M2008.02 <- M2008.01[order(-M2008.01$V3),] 
M2008.02$Crank <- seq(1:2978) # Create Ranking based on number of connections

#-------2009----------
#Remove state and nation rows
temp1 <- irs09_10in[which (irs06_07in$State_Code_Origin!=96), ]
temp2 <- temp1[which (temp1$State_Code_Origin!=97), ]
temp3 <- temp2[which (temp2$County_Code_Origin!=0), ]
temp4 <- temp3[which (temp3$codeD != temp3$codeO),]

M2009 <- ddply(temp4, .(codeD), function(df) c(sum(df$Return_Num), sum(df$Exmpt_Num),
                                               length(df$Return_Num), sum(df$Aggr_AGI), mean(df$year)))
M2009$Tmig <- M2009$V1 + M2009$V2 #Create Total Migrants Column
M2009.01 <- M2009[order(-M2009$Tmig),]
M2009.01$Mrank <- seq(1:2965) # Create Ranking based on Number of Migrants
M2009.02 <- M2009.01[order(-M2009.01$V3),] 
M2009.02$Crank <- seq(1:2965) # Create Ranking based on number of connections


inflows <- rbind(M2004.02, M2005.02, M2006.02, M2007.02, M2008.02, M2009.02)

#Merge County and Aggregated Inflows
#-------
m2009 <- merge(M2009.02, county2009,
                by.x="codeD", by.y="code")
m2008 <- merge(M2008.02, county2009,
               by.x="codeD", by.y="code")
m2007 <- merge(M2007.02, county2009,
               by.x="codeD", by.y="code")
m2006 <- merge(M2006.02, county2009,
               by.x="codeD", by.y="code")
m2005 <- merge(M2005.02, county2009,
               by.x="codeD", by.y="code")
m2004 <- merge(M2004.02, county2009,
               by.x="codeD", by.y="code")


whole <- rbind(m2009, m2008, m2007, m2006, m2005, m2004)
names(whole) <- c("codeD", "Return_Num", "Exmpt_Num", "Conections", "Aggr_AGI", "year", "Tmig", "Mrank",
                  "Crank", "StateC", "CountyC", "StateAbbr", "CName", "TReturn", "TExmpt", "AGI", "Wages_Sal",
                  "Dividend", "Interest")

fData <- read.csv("/Volumes/USB DISK/IRSmig/Tabular data/states/test1.csv")

full2 <- merge(whole, fData,
               by.x=c("year", "StateAbbr", "CountyC"),
               by.y=c("V19", "state", "COUNTYFP00"), all.x=T)

names(full2) <- c("year", "StateAbbr", "CountyC","codeD", "Return_Num", "Exmpt_Num", "Conections", "Aggr_AGI",  "Tmig", "Mrank",
                  "Crank", "StateC", "CName", "TReturn", "TExmpt", "AGI", "Wages_Sal",
                  "Dividend", "Interest", "x", "T_EMP", "empLT29",
                  "emp30_54", "empGT55", "earnLow", "earnMid", "earnHigh",
                  "workWhite", "workBlack", "workAIAN", "workAsian", "workMult",
                  "workNLatino", "workLatino", "LTHS", "HS", "AS", "BS")

full3 <- full2[which (full2$CountyC!=0), ]

mMig <- tapply(full3$Tmig, full3$year, mean)
full3$mMig  <-  mMig[as.character(full3$year)]
full3$cMig <- full3$Tmig - full3$mMig
full3$Pop <- full3$TReturn + full3$TExmpt

#Create FIPS Codes
#-------------
full4 <- full3
full4$StateFIPS <- ifelse(nchar(full4$StateC) == 1,
                          paste(0, full4$StateC, sep = ""), 
                          full4$StateC)

full4$CFIPS1 <-  ifelse (nchar(full4$CountyC) ==1, 
                         paste(0, full4$CountyC, sep = ""), 
                         full4$CountyC)

full4$CFIPS3 <-  ifelse (nchar(full4$CFIPS1) == 2,
                         paste(0, full4$CFIPS1, sep = ""),
                         full4$CFIPS1)

full4$FIPS <- paste(full4$StateFIPS, full4$CFIPS3, sep = "")
#-------------

#Merge OD Pairs with County Files
#-----
#Merge county and in-migration files, merge by state and county of origin
in2009 <- merge(county2009, irs09_010in, 
                by.x=c("State_Code", "County_Code"), 
                by.y=c("State_Code_Origin", "County_Code_Origin"))
in2008 <- merge(county2008, irs08_09in, 
                by.x=c("State_Code", "County_Code"), 
                by.y=c("State_Code_Origin", "County_Code_Origin"))
in2007 <- merge(county2007, irs07_08in, 
                by.x=c("State_Code", "County_Code"), 
                by.y=c("State_Code_Origin", "County_Code_Origin"))
in2006 <- merge(county2006, irs06_07in, 
                by.x=c("State_Code", "County_Code"), 
                by.y=c("State_Code_Origin", "County_Code_Origin"))
in2005 <- merge(county2005, irs05_06in, 
                by.x=c("State_Code", "County_Code"), 
                by.y=c("State_Code_Origin", "County_Code_Origin"))
in2004 <- merge(county2004, irs04_05in, 
                by.x=c("State_Code", "County_Code"), 
                by.y=c("State_Code_Origin", "County_Code_Origin"))

#--------
#Merge merged files by state and county of destination
in2009.1 <- merge(in2009, county2009,
                  by.x=c("State_Code_Dest", "County_Code_Dest"),
                  by.y=c("State_Code", "County_Code"))
in2008.1 <- merge(in2008, county2008,
                  by.x=c("State_Code_Dest", "County_Code_Dest"),
                  by.y=c("State_Code", "County_Code"))
in2007.1 <- merge(in2007, county2007,
                  by.x=c("State_Code_Dest", "County_Code_Dest"),
                  by.y=c("State_Code", "County_Code"))
in2006.1 <- merge(in2006, county2006,
                  by.x=c("State_Code_Dest", "County_Code_Dest"),
                  by.y=c("State_Code", "County_Code"))
in2005.1 <- merge(in2005, county2005,
                  by.x=c("State_Code_Dest", "County_Code_Dest"),
                  by.y=c("State_Code", "County_Code"))
in2004.1 <- merge(in2004, county2004,
                by.x=c("State_Code_Dest", "County_Code_Dest"),
                by.y=c("State_Code", "County_Code"))

# .x is the origin, and .y equals destination
in2009.1$year  <- 2009
in2008.1$year  <- 2008
in2007.1$year  <- 2007
in2006.1$year  <- 2006
in2005.1$year  <- 2005
in2004.1$year  <- 2004

irs  <- rbind(in2009.1, in2008.1, in2007.1, in2006.1, in2005.1, in2004.1)# bind all year files into general state file

# Merge double merge and LEDH data by state, county and year of origin
 


mig01 <- merge(irs, fData,
             by.x=c("year", "State_Abbrv.y", "County_Code"),
             by.y=c("V19", "state", "COUNTYFP00"))

# Merge tripple merge and LEDH data by state, county and year of destination
mig <- merge(mig01, fData,
             by.x=c("year", "State_Abbrv.y", "County_Code_Dest"),
             by.y=c("V19", "state", "COUNTYFP00"))

#Write out the data.frame as a csv to save the work
write.csv(mig, file = "/Volumes/USB DISK/IRSmig/Tabular data/full.csv")
write.csv(mig, file = "L:/IRSmig/Tabular data/named.csv")


#Rename variables
names(mig) <- c("Year", "StateA_D", "CountyC_D", "CountyC_O", "StateC_D", "StateC_O", 
                "StateA_O", "CountyN_O", "Return_O", "Exmpt_O", "AGI_O", "Wage_O",
                "Div_O", "Int_O", "CountyN_D", "MReturn", "MExmpt", "MAAGI",
                "StateA_O2", "CountyN_O2", "Return_D", "Exmpt_D", "AGI_D",
                "Wage_D", "Div_D", "Int_D", "CountyC_O2", "T_EMP_O", "empLT29_O",
                "emp30_54_O", "empGT55_O", "earnLow_O", "earnMid_O", "earnHigh_O",
                "workWhite_O", "workBlack_O", "workAIAN_O", "workAsian_O", "workMult_O",
                "workNLatino_O", "workLatino_O", "LTHS_O", "HS_O", "AS_O", "BS_O",
                "CountyC_D2", "T_EMP_D", "empLT29_D", "emp30_54_D", "empGT55_D", 
                "earnLow_D", "earnMid_D", "earnHigh_D",
                "workWhite_D", "workBlack_D","workAIAN_D","workAsian_D", "workMult_D",
                "workNLatino_D", "workLatino_D", "LTHS_D", "HS_D", "AS_D", "BS_D")

#Create difference score between origin and destination for all variables over time
attach(mig)
mig$D_Tjobs <- T_EMP_D - T_EMP_O
mig$D_jobsLT29y <- empLT29_D - empLT29_O
mig$D_jobs30_54 <- emp30_54_D - emp30_54_O
mig$D_jobsGT55 <- empGT55_D - empGT55_O
mig$D_earnLT1250 <- earnLow_D - earnLow_O
mig$D_earnTo3333 <- earnMid_D - earnMid_O
mig$D_earnGT3333 <- earnHigh_D - earnHigh_O
mig$Pop_O <- Return_O + Exmpt_O
mig$Pop_D <- Return_D + Exmpt_D
mig$Tmig <- MReturn + MExmpt
mig$D_Pop <- mig$Pop_D - mig$Pop_O


keepOD <- c("Year", "StateA_D", "CountyC_D","CountyC_D2", "CountyN_D", "StateA_O", "StateA_O2", "CountyC_O", "CountyC_O2", "CountyN_O", "CountyN_O2")
mergeCheck <- mig[keepOD]

# Try using a hierarchical model with year as a second level, possily adding metro areas as a third
mig$year2 <- as.factor(mig$Year)
mig3 <- mig[which (mig$D_Tjobs!=0),]
mig02 <- mig[which (mig$CountyC_D==0),]
#Pull National Level data
nat2009 <- irs07_08in[1:4,]
  nat2009$Year <- 2009
nat2008 <- irs08_09in[1:4,]
  nat2008$Year <- 2008
nat2007 <- irs07_08in[1:4,]
  nat2007$Year <- 2007
nat2006 <- irs06_07in[1:4,]
  nat2006$Year <- 2006
nat2005 <- irs05_06in[1:4,]
  nat2005$Year <- 2005
nat2004 <- irs04_05in[1:4,]
  nat2004$Year <- 2004


nat <- rbind(nat2009, nat2008, nat2007, nat2006, nat2005, nat2004)
nat$Mig <- nat$Return_Num + nat$Exmpt_Num
n<-ggplot(nat,aes(x=Year,y=Mig,group=County_Name, colour=County_Name)) # Plot the National Data by type of migration
n+geom_line()
plot(nat$Mig ~ nat$Year)
#Simple Hierarchical model to look at the influence of time, or the type of migration
hmod01 <- lmer(Mig ~ Aggr_AGI + (1|Year), nat)
hmod02 <- lmer(Mig ~ Aggr_AGI + as.factor(Year) + (1|County_Name), nat)


#Yearly SNA?

#Atempt to create vertices, and an edge list
t1 <- data.frame(unique(in2004.1$County_Name))
t2 <- data.frame(unique(in2004.1$County_Name.x))
names(t1) <- "x"
names(t2) <- "x"
t3 <- rbind(t1, t2)
nodes <- unique(t5)

#Just removing columns in the hope of getting OD pairs
td01 <- in2004.1[,c("County_Name", "County_Name.x", "Return_Num.y", "Exmpt_Num.y")]
td02 <- td01[which (td01$County_Name!= td01$County_Name.x),]
td02$TMig <- td02$Return_Num.y + td02$Exmpt_Num.y
write.csv(td02, file = "/Volumes/USB DISK/IRSmig/Tabular data/natest.csv") # write this out to get rid of the row.names column

g <- graph.data.frame(read.csv("/Volumes/USB DISK/IRSmig/Tabular data/natest.csv"), directed=T)

#------------------- This bit of code was shamelessly stolen from a NY r meetup in 2009
# Create a new dataframe with centrality metrics
cent<-data.frame(bet=betweenness(g),eig=evcent(g)$vector)
# evcent returns lots of data associated with the EC, 
# but we only need the leading eigenvector

# We will use the residuals in the next step as part
# of the visualization
res<-as.vector(lm(eig~bet,data=cent)$residuals)
cent<-transform(cent,res=res)

library(ggplot2)
# We use ggplot2 to make things a it prettier
p<-ggplot(cent,aes(x=bet,y=eig,label=rownames(cent),colour=res,
                   size=abs(res)))+xlab("Betweenness Centrality")+ylab("Eigenvector
                                                                       Centrality")
# We use the residuals to color and shape the points of our plot,
# making it easier to spot outliers.
pdf('key_actor_analysis.pdf')
p+geom_text()+opts(title="Migration")
# We use the geom_text function to plot the actors' ID's rather than points
# so we know who is who
dev.off()

#---------------------------------------------


#Map Stuff
library(maptools)
library(spdep)
library(RColorBrewer)
library(classInt)
  # Read in dbf from shp and merge with data by year
shp <- read.dbf("/Volumes/USB DISK/IRSmig/GIS/SHP/2010County.dbf") # don't modify in case we the shp breaks
#s2 <- read.dbf("/Volumes/USB DISK/IRSmig/GIS/SHP/Ctest.dbf") #secondary county shp

s2004 <- merge(shp, full4[which (full4$year==2004),], by.x="GEOID10", by.y = "FIPS2", all.x=T)
s2004$Jden <- s2004$T_EMP / s2004$ALAND10
s2004$Pden <- s2004$Pop / s2004$ALAND10
keepFields <- c("GEOID10", "OBJECTID", "NAMELSAD10","FUNCSTAT10", "ALAND10", "INTPTLAT10", "INTPTLON10", 
                "year", "Pop", "Tmig", "Mrank", "Crank", "Metro", "Micro", "AGI", "Aggr_AGI", 
                "Wages_Sal", "Dividend", "Interest", "Conections",
                "T_EMP", "earnLow", "earnMid", "earnHigh", "Jden", "Pden", "empLT29",
                "emp30_54", "empGT55")
s2004.01 <- s2004[keepFields]
write.dbf(s2004.01, file="/Volumes/USB DISK/IRSmig/GIS/SHP/2010County1.dbf")

s2005.01 <- s2004[keepFields]
s2006.01 <- s2004[keepFields]
s2007.01 <- s2004[keepFields]
s2008.01 <- s2004[keepFields]
s2009.01 <- s2004[keepFields]

newF <- rbind(s2004.01, s2005.01, s2006.01, s2007.01, s2008.01, s2009.01)

mod1 <- lmer(Tmig~ 1 + (1| Metro), data=newF)
mod2 <- lmer(Tmig~ T_EMP + AGI + Conections + Pop + (Metro | year), data=newF)

mod3 <- lmer(Tmig~ Conections + earnLow  + earnHigh + empLT29 + emp30_54 +
             + Jden + Pden + (Metro | year), data=newF)

mod4 <- glm(Tmig~ Conections + earnLow  + earnHigh + empLT29 + emp30_54 +
           + Jden + Pden + Metro + as.factor(year), data=newF)
#export new dbf

  #Read in the county shapefile
cmap <- readShapePoly("/Volumes/USB DISK/IRSmig/GIS/SHP/2010County1.shp")

# nclr  <- 9
# plotvar <- cmap$Tmig
# class <- classIntervals(plotvar, nclr, style = "pretty")
# plotclr <- brewer.pal(nclr, "Blues")
# colcode = findColours(class, plotclr, digits = 3)
# plot(cmap)
# title(main = "Internal Migration 2004")

nbC <- poly2nb(cmap) # Boundary Neighborhood function - Spatial weight fail due to empty neighbor sets

coord <- coordinates(cmap)
cnbC <- knn2nb(knearneigh(coord, k=10))
weightC <- nb2listw(cnbC, style = "W")# 

#Morans I
gm2004 <- moran.test(cmap$Tmig, listw = weightC, alternative = "two.sided", na.action= na.omit)

lm2004 <- glm(Tmig ~ T_EMP, data=cmap, family=poisson(link=log)) # All significant
lm.morantest(lm2004, weightC) # Significant

lag2004 <- lagsarlm(Tmig ~ T_EMP, data=cmap, weightC)