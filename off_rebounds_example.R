library(tidyverse)

#link <- c("http://www.goheels.com/ViewContent.dbml?SPSID=668156&SPID=12965&DB_LANG=C&SITE=UNC&DB_OEM_ID=3350&CONTENT_ID=1981870")

# function to scrape data from play-by-play url
#  creates data frame with four columns: player who got offensive rebounder, shooter before offensive rebound, type of shot, opponent
offensiverebs <- function(link) {
  #create blank data frame to fill
  offrebs <- data.frame(Opponent=c(0),Rebounder=c(0),Shooter=c(0),ShotType=c(0)) 
  
  playbyplay <- readLines(link)
  
  #assign variables for home and away teams
  teams <- grep("SCORE  MAR",playbyplay)
  teams <- strsplit(playbyplay[teams[1]],"TIME")
  hometeam <- teams[[1]][1]
  hometeam <- strsplit(hometeam,": ")
  hometeam <- hometeam[[1]][2]
  hometeam <- sub("\\s+$", "", hometeam) #remove trailing spaces
  awayteam <- teams[[1]][2]
  awayteam <- strsplit(awayteam,": ")
  awayteam <- awayteam[[1]][2]
  
  #get play-by-play for UNC only
  if (hometeam == "North Carolina") {
    #take left side of playbyplay lines
    for (i in 1:length(playbyplay)) {
      playbyplay[i] <-  substring(playbyplay[i],1,48)
      playbyplay[i] <- sub("\\s+$", "", playbyplay[i]) #trim trailing spaces
      opponent <- awayteam
    }
  } 
  if (awayteam == "North Carolina") {
    #take right side of playbyplay lines
    for (i in 1:length(playbyplay)) {
      playbyplay[i] <- substring(playbyplay[i],68,nchar(playbyplay[i]))
      opponent <- hometeam
    }
  }
  
  #get lines in play-by-play where an offensive rebound occurs
  orindex <- grep("REBOUND \\(OFF)",playbyplay)
  
  #for each OR, get rebounder, shooter, and type of shot
  for (i in 1:length(orindex)) {
    rebound <- playbyplay[orindex[i]]
    rebound <- strsplit(rebound,"by ")
    rebounder <- rebound[[1]][2]
    shot <- playbyplay[orindex[i]-1]
    shot <- strsplit(shot," by ")
    shooter <- shot[[1]][2]
    shottype <- strsplit(shot[[1]][1],"MISSED ")
    shottype <- shottype[[1]][2]
    offrebs <- rbind(offrebs,c(opponent,rebounder, shooter, shottype))
  }
  offrebs <- filter(offrebs,Shooter!=0) #remove row of zeros created when initially creating dataframe
  return(offrebs)
  
}



#create function to run season of links all at once
seasonORs <- function(season) {
  #create blank data frame
  reboundData <- data.frame()
  
  #loop through each game link in season
  for (i in 1:length(season)) {
    gameData <- offensiverebs(season[i])
    print(gameData)
    reboundData <- rbind(reboundData,gameData)
  }
  return(reboundData)
  
}