library(XML)
library(stringr)
library(plyr)
library(xlsx)

#Need the following statement since rJava has problems on my computer
#Sys.setenv(JAVA_HOME='C:\Program Files\Java\jre7')



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

gameData <- ldply(gameTables,rbind.fill)

gameTitle <- as.character(gameData[,1])

gameTitle <- gsub(pattern = "<U+2606>",x = gameTitle,replacement = "")

gameConsoleDataFrame <- data.frame(cbind(gameTitle,systemName))

colnames(gameConsoleDataFrame ) <- c("Mario.Games","Console")

gameConsoleDataFrame<- gameConsoleDataFrame[-which(gameConsoleDataFrame$Mario.Games== ""),]

gameConsoleDataFrame<- gameConsoleDataFrame[-which(gameConsoleDataFrame$Mario.Games == "Search TMK"),]

colnames(gameConsoleDataFrame ) <- c("Mario Games","Console")

rownames(gameConsoleDataFrame) <- NULL

write.xlsx(gameConsoleDataFrame,"MarioAppearCategories.xlsx") # Excel spreadsheet that contains game names and categories (console names are abbreviated)

#catPos stores the row numbers where Categories or Console Names are mentioned instead of names of games in the games column

catPos <- which(gameConsoleDataFrame[,1] %in% c("Starring roles",
                                                "Cameo appearances and allusions","Panorama Screen",
                                                "Spin-offs","e-Reader","Demos","Crossovers","Non-downloadable demos",
                                                "3DS Channels","Virtual Console","Other","Channels","64DD","Nintendo 64DD BIOS",
                                                "Hardware","Nintendo Super System","Nintendo Vs. System",
                                                "Multi Screen","New Wide Screen"))

justGames <- gameConsoleDataFrame[-catPos,] #Gets rid of category name strings

justGames[,"Mario.Games"] <- as.character(justGames[,"Mario.Games"])

justGames[,"Console"] <- as.character(justGames[,"Console"])

#Code that changes abbreviations of console names into their full names (13 lines of code below)

fullSystemName <- function(consoleName,pattern,replacement) {consoleName <- str_replace_all(string = consoleName,pattern = pattern, replacement = replacement)}

justGames[,"Console"] <- fullSystemName(justGames[,"Console"],pattern = "GW", replacement = "Game & Watch")

justGames[,"Console"] <- fullSystemName(justGames[,"Console"],pattern = "GBA", replacement = "Game Boy Advance")

justGames[,"Console"] <- fullSystemName(justGames[,"Console"],pattern = "GB", replacement = "Game Boy")

justGames[,"Console"] <- fullSystemName(justGames[,"Console"],pattern = "GCN", replacement = "GameCube")
 

justGames[,"Console"] <- fullSystemName(justGames[,"Console"],pattern = "N64", replacement = "Nintendo 64")

justGames[,"Console"] <- fullSystemName(justGames[,"Console"],pattern = "NDS", replacement = "Nintendo DS")

justGames[,"Console"] <- fullSystemName(justGames[,"Console"],pattern = "SNES", replacement = "Super Nintendo")


justGames[,"Console"] <- fullSystemName(justGames[,"Console"],pattern = "NES", replacement = "Nintendo Entertainment System")

justGames[,"Console"] <- fullSystemName(justGames[,"Console"],pattern = "Nintendo Entertainment System", replacement = "Nintendo Entertainment System (NES)")


justGames[,"Console"] <- fullSystemName(justGames[,"Console"],pattern = "Super Nintendo", replacement = "Super Nintendo (SNES)")


justGames[,"Console"] <- fullSystemName(justGames[,"Console"],pattern = "VB", replacement = "Virtual Boy")

justGames[,"Console"] <- fullSystemName(justGames[,"Console"],pattern = "WiiU", replacement = "Wii U")


names(justGames) <- c("Mario Games", "Console") #These names appear as column headings in the Excel spreadsheet


write.xlsx(justGames,"MarioAppearances.xlsx") #Write the Mario games and the corresponding console names to an Excel spreadsheet


#Code which downloads a copy of the files
#for(i in 1:length(gamePages))
#{
  #download.file(url = gamePages[i],destfile = paste0("./MarioFiles/",unique(systemName)[i],"-",format(Sys.time(), "%a %b %d %Y"),".xml"))
  #download.file(url = gamePages[i],destfile = paste0("./MarioFiles/",unique(systemName)[i])
#}
