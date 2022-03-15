library(tidyverse)
library(httr)
library(rjson)

issn <- "1526-5161"

url <- paste0("https://api.elsevier.com/content/search/scopus?query=ISSN(", issn, ")&apiKey=bd2c8d4ca7a5db08585fbeedd3b66405&count=25&start=26&httpAccept=application/json")

response <- GET(url)

result <- fromJSON(rawToChar(response$content))$`search-results`

tot <- as.numeric(result$`opensearch:totalResults`)

it <- tot %/% 25 


items <- list()
for (i in 0:it) {
  count = 25 * i +1
  url <- paste0("https://api.elsevier.com/content/search/scopus?query=ISSN(", issn, ")&apiKey=bd2c8d4ca7a5db08585fbeedd3b66405&count=25&start=", count, "&httpAccept=application/json")
  response <- GET(url)
  
  results <- fromJSON(rawToChar(response$content))$`search-results`$entry
  
  for (j in 1:length(results)) {
    items <- bind_rows(items, as.data.frame(do.call(cbind, results[[j]])))
  }
  print(i)
}

result$entry[[1]]
