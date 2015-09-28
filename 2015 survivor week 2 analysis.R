# favorited teams, in order: NO, BAL, MIA, STL, IND, TEN, PIT, ARI, CAR, KC, PHI
# didn't have ready access to historical win likelihoods for the remaining teams/picks - this covers 98% of the Yahoo! distribution
fav_win_odds <- c(.809, .699, .699, .623, .744, .518, .685, .539, .614, .612, .675) # from Pinnacle, via Vegaswatch http://www.vegaswatch.org/2015/09/2015-nfl-survivor-week-2.html
percent_choosing <- c(.4992, .1569, .1266, .0607, .0489, .0297, .0282, .0094, .0073, .0043, .0040) # from Yahoo! Sports http://football.fantasysports.yahoo.com/survival/pickdistribution?type=&week=2

# adjust for the fact that only ~98% of picks counted by allocating remaining ~2% proportionately
percent_choosing <- percent_choosing / sum(percent_choosing)

# Run a million simulations
set.seed(1)
perc_winners <- numeric(1000000)
for(i in 1:1000000) {
  rands <- runif(length(fav_win_odds))
  perc_winners[i] <- sum(percent_choosing[fav_win_odds > rands])
}


actual_winners <- sum(percent_choosing[7:9])

# percentile and likelhood of result occurring
likelihood <- length(perc_winners[perc_winners <= actual_winners]) / length(perc_winners)
chance <- 1/likelihood

library(ggplot2)
ggplot(as.data.frame(perc_winners), aes(x = perc_winners)) +
  geom_histogram(binwidth = .01) +
  geom_vline(x = actual_winners, color = "red") + # actual % who won
  geom_vline(x = median(perc_winners), color = "blue") + # median expected result
  geom_vline(x = quantile(perc_winners, .01), color = "orange") + # 1st percentile, for reference
  theme_bw()