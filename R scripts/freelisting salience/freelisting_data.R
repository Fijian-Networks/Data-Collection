# testing on coded csv with bias
tucsv <- tidyUnitCsv

# Calc Salience
FL <-CalculateSalience(tucsv)

# DealWithDoubles handles double ups in single id's choices, in case they list the same thing twice
FL.S <- SalienceByCode(FL, dealWithDoubles = "MAX")
