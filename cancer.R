Neopro<- read.csv(file="c:/Users/user/Desktop/Cancer_reading.csv", header=TRUE, sep=",")
library(Boruta)
# Decide if a variable is important or not using Boruta
borutaoutput <- Boruta(Cancer_reading ~ ., data=na.omit(Neopro), doTrace=2)  # perform Boruta search
# Confirmed 10 attributes: Humidity, Inversion_base_height, Inversion_temperature, Month, Pressure_gradient and 5 more.
# Rejected 3 attributes: Day_of_month, Day_of_week, Wind_speed.
borutasignif <- names(borutaoutput$finalDecision[borutaoutput1$finalDecision %in% c("Confirmed", "Tentative")])  # collect Confirmed and Tentative variables
print(borutasignif)  # significant variables
#=> [1] "Month"                 "ozone_reading"         "pressure_height"      
#=> [4] "Humidity"              "Temperature_Sandburg"  "Temperature_ElMonte"  
#=> [7] "Inversion_base_height" "Pressure_gradient"     "Inversion_temperature"
#=> [10] "Visibility"
plot(boruta_output, cex.axis=.7, las=2, xlab="", main="Variable Importance")  # plot variable importance