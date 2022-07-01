library(vroom)
library(tidyverse)

download.file("https://policeuk-data.s3.amazonaws.com/download/eab6c85b27769b194bb3127dc4df808b2f948098.zip", 
              'StripSearches.zip')
files <- unzip('StripSearches.zip', list=TRUE)[[1]]
d3 <- map_df(files, ~vroom(.x, id = "file_name"))
d3$date <- substr(d3$file_name,1,7)
d3$year <- substr(d3$file_name,1,4)
d3$force <- substr(d3$file_name, 17, 9999)
d3$race <- NA
d3$race <- substr(d3$`Self-defined ethnicity`, 1, 5)
d3$race[is.na(d3$race)] <- d3$`Officer-defined ethnicity`[is.na(d3$race)]
d3 <- drop_na(d3, file_name)
stripsearches <- d3[d3$`Removal of more than just outer clothing` == "TRUE",]
stripsearches <- drop_na(stripsearches, file_name)


stripsearches %>%
  count(`Outcome`,year) %>%
  group_by(year) %>%
  mutate(freq = (n / sum(n))) %>%
  arrange(year) %>%
  pivot_wider(names_from = year, values_from = c(n, freq))


d3 %>%
  count(Outcome,year) %>%
  group_by(year) %>%
  mutate(freq = (n / sum(n))) %>%
  arrange(year) %>%
  pivot_wider(names_from = year, values_from = c(n, freq))