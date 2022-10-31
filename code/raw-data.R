packages <- c("tidyverse","here","VIM")

for (package in packages) {
  if (!require(package, character.only=T, quietly=T)) {
    install.packages(package, repos='http://lib.stat.cmu.edu/R/CRAN')
  }
}

for (package in packages) {
  library(package, character.only=T)
}

## import data from web:
file_loc <- url("https://cdn1.sph.harvard.edu/wp-content/uploads/sites/1268/1268/20/nhefs.csv")
nhefs_data <- read_csv(file_loc)

# let's look at the data
dim(nhefs_data)

nhefs_data


## select variables
nhefs_data <- nhefs_data %>% 
  select(seqn, qsmk, sbp, dbp, sex, age, race, income, wt82_71, death)

## is there any missing?
aggr(nhefs_data)

propMissing <- function(x){
  mean(is.na(x))
}

apply(nhefs_data,2,propMissing)

## delete missing data, create MAP, and remove blood pressure variables
nhefs_data <- nhefs_data %>% 
  na.omit() %>% 
  mutate(map = dbp + (sbp - dbp)/3) %>% 
  select(-sbp, -dbp)

## how is age distributed?
ggplot(nhefs_data) + geom_histogram(aes(age))
ggsave(filename = here("figures","nhefs_age_histogram.pdf"))

## write the analytic dataset to the data folder using here:
write_csv(nhefs_data, file = here("data","analytic_data.csv"))
