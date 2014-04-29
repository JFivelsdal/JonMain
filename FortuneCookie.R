fCookie <- function()
{

#Fortune cookie script

fortuneCookie <- read.csv("FortuneCookie.csv",header = FALSE)

cookieString <- paste0(as.character(fortuneCookie[1][[1]]),as.character(fortuneCookie[2][[1]]))

nonEmpty <- NULL

nonEmpty <- grep(pattern = "([A-Za-z])",cookieString,fixed = FALSE)

if(length(nonEmpty) > 0)
{
  cookieString <- cookieString[nonEmpty]
}
messageID <- 0 #index number for fortune cookie strings 

while(messageID < 1  | messageID > length(cookieString))
{
messageID <- round(rnorm(1,mean = 35,sd = 30))  #Generates index number of fortune cookie message
}

print(messageID) # Prints out the number

print(cookieString[messageID])

}