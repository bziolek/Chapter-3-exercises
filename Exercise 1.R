
#Load packages
library(dplyr)
library(tidyr)
library(readr)

#Import dataset and change product code column name
refine_original <- read.csv("refine_original.csv")
colnames(refine_original)[2] <- "Product_code_number"
#View(refine_original)

#1 Clean up brand names

##Company column to lower case, identify unique company values, create vectors of unique company values
clean_company <- mutate(refine_original, company = tolower(company))
company_unique <- distinct(select(clean_company, company))
philips_group <- c("phillips", "philips", "phllips", "phillps", "fillips", "phlips")
akzo_group <- c("akzo", "akz0", "ak zo")
van_houten_group <- c("van houten")
unilever_group <- c("unilver", "unilever")

##Define correct names
philips <- "philips"
akzo <- "akzo"
van_houten <- "van houten"
unilever <- "unilever"

##Update company column to correct name
clean_company <- clean_company %>% mutate(company = case_when(
  .$company %in% philips_group ~ philips,
  .$company %in% akzo_group ~ akzo,
  .$company %in% van_houten_group ~ van_houten,
  .$company %in% unilever_group ~ unilever))

#2 Separate product code and number
 
 split_product_info <- clean_company %>% separate(Product_code_number, into = c("product_code", "product_number"), sep = "-")

#3 Add product categories

## Define category variables
p <- "Smartphone"
v <- "TV"
x <- "Laptop"
q <- "Tablet"
 
## Add new column and populate with category based on product_code
product_cat <- split_product_info %>% mutate(product_category = case_when(
  .$product_code == "p" ~ p,
  .$product_code == "v" ~ v,
  .$product_code == "x" ~ x,
  .$product_code == "q" ~ q))

#4 Add full address for geocoding

geocoding <- product_cat %>% unite(full_address, address:country, sep = ",")

#5 Create dummy variables for company and product category

install.packages("dummies")
library(dummies)

dummy <- dummy.data.frame(geocoding, names = c("company", "product_category"), sep = "_")

#6 Convert resulting table to CSV file
write.csv(dummy, file = "refine_clean.csv")
