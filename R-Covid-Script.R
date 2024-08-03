rm(list=ls()) 
library(Hmisc) 

data <- read.csv("C:/Users/jaden/OneDrive/Desktop/Projects/COVID19_line_list_data.csv")
describe(data) #Hmisc command

# Clean inconsistencies (death uses 0/1/date), remove date
# New column: if death != 0, person died, if not, they did not
data$death_dummy <- as.integer(data$death != 0)

#check --> should only be 0 and 1
unique(data$death_dummy)

#death rate
sum(data$death_dummy)/nrow(data)
#Death Rate is about 5.8%

# Age
# Null Hypothesis: Age has no effect on death rate
dead = subset(data, death_dummy == 1)
alive = subset(data, death_dummy == 0)
mean(dead$age, na.rm = TRUE)
mean(alive$age, na.rm = TRUE)
#need na.rm = TRUE b/c some ages are empty
# check for statistical significance: t test
t.test(alive$age, dead$age, alternative = "two.sided", conf.level = 0.95)
# Confidence interval: 95% confidence that the difference in age between alive and dead is between ~24 and ~16 years 
# Those who live are usually much younger
# p-value ~= 0 < 0.05 so reject null hypothesis
# Conclusion: result is statistically significant

# Gender
# Claim: Gender has no effect on death rate
men = subset(data, gender == "male")
women = subset(data, gender == "female")
mean(men$death_dummy, na.rm = TRUE) # ~8.4%
mean(women$death_dummy, na.rm = TRUE) # ~3.7%
#need na.rm = TRUE b/c some ages are empty
# check for statistical significance: t test
t.test(men$death_dummy, women$death_dummy, alternative = "two.sided", conf.level = 0.99)
# Confidence interval: 99% confidence that men have from ~0.8% to 8.8% higher chance of dying
# p-value ~= 0.002 < 0.05 so reject nul hypothesis
# Conclusion: statistically significant --> men have higher death rate than women


#Country: China vs Japan
#Claim: Location has no effect on death rate
china = subset(data, country == "China")
japan = subset(data, country == "Japan")
mean(china$death_dummy, na.rm = TRUE) # ~19.8%
mean(japan$death_dummy, na.rm = TRUE) # ~2.6%
#need na.rm = TRUE b/c some ages are empty
# check for statistical significance: t test
t.test(china$death_dummy, japan$death_dummy, alternative = "two.sided", conf.level = 0.99)
# Confidence interval: 99% confidence that a person from China has from ~9.2% to ~25.1% higher chance of dying than a person from Japan
# p-value ~= 0 < 0.05 so reject null hypothesis
# Conclusion: statistically significant --> China has higher death rate than Japan

