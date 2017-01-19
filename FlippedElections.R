library(dplyr)
library(MASS)

election<-read.csv("election16candidates.csv", na.strings = "", stringsAsFactors = F)

#CLEANING AND MANIPULATING THE DATA

#fill in missing values with zeros
election$DEMvotes[is.na(election$DEMvotes)]<-0
election$REPvotes[is.na(election$REPvotes)]<-0
election$OtherVotes[is.na(election$OtherVotes)]<-0
election$DEMchoice[is.na(election$DEMchoice)]<-"None"
election$REPchoice[is.na(election$REPchoice)]<-"None"
election$OtherChoice[is.na(election$OtherChoice)]<-"None"
election$OtherParty[is.na(election$OtherParty)]<-"None"

#create new columns for winner name, party, votes, margin
election$WinnerVotes<-pmax(election$DEMvotes, election$REPvotes, election$OtherVotes)
election$WinnerParty<-ifelse(election$WinnerVotes==election$DEMvotes, "DEM", ifelse(election$WinnerVotes==election$REPvotes, "REP","Other"))
for (i in 1:170) {
  if (election$REPvotes[i] > election$DEMvotes[i] && election$REPvotes > election$OtherVotes) {
    election$Winner[i]<-election$REPchoice[i]
    election$Loser[i]<-election$DEMchoice[i]
    #note: winner is overall winner, loser is only DEM or REP, not third party
    election$Margin[i]<-election$REPvotes[i]-election$DEMvotes[i] }
    #note: margin is only between two main party candidates
  else if (election$DEMvotes[i] > election$OtherVotes[i]) {
    election$Winner[i]<-election$DEMchoice[i]
    election$Loser[i]<-election$REPchoice[i]
    election$Margin[i]<-election$DEMvotes[i] - election$REPvotes[i] }
  else {
    election$Winner[i]<-election$OtherChoice[i] }
}

#create new column for ratio of votes needed to win over actual votes
for (i in 1:170) {
  if (election$Loser[i]!="None") {
    election$MarginRatio[i]<-(election$WinnerVotes[i]+1)/(election$WinnerVotes[i]-election$Margin[i])
  } else { election$MarginRatio[i]<-0 }
}

#helper function to extract fraction numerator and denominators
getfracs <- function(frac) {
  tmp <- strsplit(attr(frac,"fracs"), "/")[[1]]
  list(numerator=as.numeric(tmp[1]),denominator=as.numeric(tmp[2]))
}

#calculate how many additional voters per existing voters needed to change election
for (i in 1:170) {
  tempfrac<-getfracs(fractions(round(election$MarginRatio[i]-1, digits = 2)))
  election$ToBring[i]<-tempfrac$numerator
  election$PerVoted[i]<-tempfrac$denominator
}

#CREATING THE SUMMARY-GENERATING FUNCTION

#print sentence of results
district_summary <- function(legislature, district) {
  #if/else statement 1: set index value
  if (toupper(legislature)=="SENATE") {
    i<-district+120
  } else {
    i<-district
  }
  #if/else statement 2:create three primary cases
  if (election$WinnerVotes[i]==(election$DEMvotes[i]+election$REPvotes[i]+election$OtherVotes[i])) {
    #case 1: uncontested
    cat(election$WinnerParty[i],"candidate",election$Winner[i],"won in an uncontested election.", sep = " ")
  } else if (election$Loser[i]!="None") {
    #case 2: at least a DEM and REP candidate
    cat(election$WinnerParty[i]," candidate ",election$Winner[i]," won this district by ",election$Margin[i],
        " votes over ",ifelse(election$WinnerParty[i]=="REP","DEM","REP")," candidate ",election$Loser[i],". ", sep = "")
  } else {
    #case 3: either a DEM or REP candidate (not both)
    # if the winner was either a DEM or a REP, there will be a third party candidate in this case
    cat(election$WinnerParty[i],"candidate",election$Winner[i],"won this district with",election$WinnerVotes[i],"votes and did not face a",
        ifelse(election$WinnerParty[i]=="REP","DEM","REP"),"candidate. ",sep = " ")
  }
  #if/else statement 3: add output sentence for third-party candidates
  #covers districts with third party candidates in cases 2 and 3 above
  if (election$OtherChoice[i]!="None" && election$WinnerParty!="Other") {
    cat(election$OtherParty[i],"candidate",election$OtherChoice[i],"also ran, recieving",election$OtherVotes[i],"votes.", sep = " ")
  }
  #if/else statement 4: add sentence describing conditions necessary to flip district
  if (election$Loser[i]!="None") {
    cat("In order for",election$Loser[i],"to win, every",election$PerVoted[i],"people who voted for them needed to bring an additional",election$ToBring[i],"voters.")
  } 
}
