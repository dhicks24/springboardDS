# Data Wrangling Ex2

# 0. Load the data into RStudio

df <- read.csv(file = "titanic_original.csv")
View(df)

# 1. Port of embarkation (find missing values and replace with "S")

df$embarked[df$embarked == ""] <- "S"

# 2. Age (calculate the mean of Age and use to populate missing values)

df$age[is.na(df$age)] <- mean(df$age, na.rm = TRUE)

# 3. Lifeboat (fill missing values with "NA")

df$boat[df$boat == ""] <- NA

# 4. Cabin (create has_cabin_number column and populate with 1 or 0)

df$has_cabin_number <- ifelse(df$cabin == "", 0, 1)

# 5. Submit on Github (write to titanic_clean.csv and submit on Gothub)

write.csv(x = df, file = "titanic_clean.csv")
