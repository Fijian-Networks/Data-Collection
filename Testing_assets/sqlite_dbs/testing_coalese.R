setwd("/Users/admin/Documents/SHAVER_NETWORK/cohesionAndConflict/Testing_assets/sqlite_dbs")

# function to join data together...
coalesce_join <- function(x, y, 
                          by = NULL, suffix = c(".x", ".y"), 
                          join = dplyr::full_join, ...) {
  joined <- join(x, y, by = by, suffix = suffix, ...)
  # names of desired output
  cols <- union(names(x), names(y))
  
  to_coalesce <- names(joined)[!names(joined) %in% cols]
  suffix_used <- suffix[ifelse(endsWith(to_coalesce, suffix[1]), 1, 2)]
  # remove suffixes and deduplicate
  to_coalesce <- unique(substr(
    to_coalesce, 
    1, 
    nchar(to_coalesce) - nchar(suffix_used)
  ))
  
  coalesced <- purrr::map_dfc(to_coalesce, ~dplyr::coalesce(
    joined[[paste0(.x, suffix[1])]], 
    joined[[paste0(.x, suffix[2])]]
  ))
  names(coalesced) <- to_coalesce
  
  dplyr::bind_cols(joined, coalesced)[cols]
}

df1 <- tibble(
  key  = c('a', 'b', 'c', 'd', 'e', 'f'),
  var1 = c(  1,   2,   3,   4,  NA,  NA),
  var2 = c( NA,  NA,  NA,  NA,   5,   6),
  var3 = c(  1,   2,   3,   4,   5,   6)
)

df2 <- tibble(
  key  = c('c', 'd', 'e', 'f'),
  var1 = c( NA,  NA,   5,   6),
  var2 = c( NA,   4,   5,  NA),
  var4 = c(  3,   4,   5,   6)
)

d <- coalesce_join(table_to_insert.participant_info,table_to_insert.meta, by = "_id")
