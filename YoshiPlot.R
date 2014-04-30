## Yoshi Draw Script
## Script to Draw Yoshi Using Parametric Equations 
## Author: Jonathan Fivelsdal
## Date: 4/27/2014

library(stringr)
library(fBasics)

#Check to see if the csv file is in the working directory, if not download the file

#if("YoshiEq.csv" %in% list.files(getwd()) == FALSE)
#{
  
 # yoshiLink <- "https://github.com/JFivelsdal/JonMain/blob/master/YoshiEq.csv"
 # download.file(yoshiLink,destfile = paste(getwd(),"YoshiEq.csv",sep = "//"),method = "internal")
  
#}

tYoshi <- data.frame(t <- seq(0,76*pi,length = 10000)) #t values for the parametric equations

yoshiData <- read.csv(file = "YoshiEq.csv",header=FALSE,stringsAsFactors = FALSE) #Read in parametric equations to draw Yoshi

#yoshiData <- read.csv(file = "C:\\Users\\Jonathan\\Desktop\\YoshiEq.csv",header=FALSE,stringsAsFactors = FALSE) #Read in parametric equations to draw Yoshi

yoshiFormula <- unlist(yoshiData) #Creates a list that stores the x and y parametric equations


#String operations to change the equation expressed in Mathematica into an expression that R understands

yoshiFormula <- str_replace_all(string = yoshiFormula,pattern = "theta",replacement = "Heaviside")

yoshiFormula <- gsub(pattern = "sgn",x = yoshiFormula, replacement = "Sign")

yoshiFormula <- gsub(pattern = " ",x = yoshiFormula, replacement = "*" )

yoshiFormula <- gsub(pattern = "*=*", x = yoshiFormula, replacement = "",fixed = TRUE)

yoshiFormula <- gsub(pattern = "x(t)", x = yoshiFormula, replacement = "",fixed = TRUE)

yoshiFormula <- gsub(pattern = "y(t)", x = yoshiFormula, replacement = "",fixed = TRUE)



xYoshi <- unlist(yoshiFormula[[1]])  # Stores x(t) formula for Yoshi

yYoshi <- unlist(yoshiFormula[[2]]) #Stores y(t) formula for Yoshi


x <- eval(parse(text = xYoshi)) #Evaluates the x coordinate formula

y <- eval(parse(text = yYoshi)) #Evaluates the y coordinate formula

tYoshi$x <- x #adds x-coordinates to the tYoshi dataframe

tYoshi$y <- y #adds y-coordinates to the tYoshi dataframe

colnames(tYoshi)[1] <- "t" #Changes the name of the column in tYoshi that stores the t-coords to t
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
plot(x,y)  #Yoshi drawn with dot characters                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
plot(x,y,type = "l") #Standing Yoshi with axes

plot(y,x,type = "l") #Flying Yoshi with axes

plot(x,y,type = "l",axes = FALSE,xlab = "",ylab = "") # Yoshi Standing w/o axes and labels

plot(y,x,type = "l",axes = FALSE, xlab = "", ylab = "")# Yoshi Flying w/o axes and labels

