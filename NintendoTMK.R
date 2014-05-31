library(XML)
library(stringr)
library(plyr)
library(xlsx)





webTMK <- "http://www.themushroomkingdom.net/" #Main page for the fan website The Mushroom Kingdom (TMK)

parseTMK <- htmlParse(webTMK) #Get the XML source of the website

#XPathTMK <- "//a[@href = 'games/']"

newXPathTMK <- "//a[contains(concat(' ', @href, ' '), 'games/')]" #XPath expression to find "href" nodes that contain 'games/'


nodesTMK <- xpathSApply(parseTMK ,newXPathTMK,xmlValue) #Retrieves the names of game consoles

TMKatt <- xpathSApply(parseTMK ,newXPathTMK,xmlAttrs) #Retrieves link parts that match the XPath expression

TMKatt <- unlist(TMKatt) #Vector of link parts that contain 'games/'

gameLinks <- grep(pattern = "games/[A-Z]",x = TMKatt,value=TRUE) #Get only the links that have a capital letter following 'games/'
gameLinks <- append(gameLinks,grep(pattern = "games/[0-9]",x = TMKatt,value=TRUE)) #This line appends the 3DS to the game console vector

systemsVec <- nodesTMK[2:17] #Get the names of the consoles from the list of nodes from the website

systemsVec <- systemsVec[-which(systemsVec == "and e-Reader")] #Remove the e-Reader entry from the names of game consoles 

gamePages <- paste0(webTMK,gameLinks) #Create the links to read tables from

gameTables <- lapply(1:length(gamePages), function(i) {readHTMLTable(gamePages[i],which = 1)}) 

systemsAddress <- unlist(lapply(1:length(gameTables), function(i) { rep(gamePages[i],nrow(gameTables[[i]]))}))

systemName <- gsub(pattern = paste0(webTMK,"games/"),replacement = "", x = systemsAddress)


gameTitle <- as.character(gameData[,1])

gameTitle <- gsub(pattern = "<U+2606>",x = gameTitle,replacement = "")

gameConsoleDataFrame <- data.frame(cbind(gameTitle,systemName))

colnames(gameConsoleDataFrame ) <- c("Console","Mario Games")

gameConsoleDataFrame<- gameConsoleDataFrame[-which(gameConsoleDataFrame$Console == ""),]

gameConsoleDataFrame<- gameConsoleDataFrame[-which(gameConsoleDataFrame$Console == "Search TMK"),]

rownames(gameConsoleDataFrame) <- NULL

write.xlsx(gameConsoleDataFrame,"MarioAppearances.xlsx")


#Code which downloads a copy of the relevant XML files
#for(i in 1:length(gamePages))
#{
 # download.file(url = gamePages[i],destfile = paste0("./MarioFiles/",unique(systemName)[i],"-",format(Sys.time(), "%a %b %d %Y"),".xml"))
#}