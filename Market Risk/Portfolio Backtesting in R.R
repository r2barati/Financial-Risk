# Load required libraries
library(quantmod)

# Set the start and end dates for backtesting
start_date <- as.Date("2010-01-01")
end_date <- as.Date("2020-12-31")

# Define the ticker symbols for the securities in the portfolio
tickers <- c("AAPL", "GOOG", "MSFT")

# Download historical data for each ticker
getSymbols(tickers, from = start_date, to = end_date)

# Combine the adjusted closing prices of all securities into one dataframe
portfolio <- merge(Cl(AAPL), Cl(GOOG), Cl(MSFT))

# Calculate the daily returns of the portfolio
portfolio_returns <- dailyReturn(portfolio)

# Define the portfolio weights (e.g., 30% AAPL, 40% GOOG, 30% MSFT)
weights <- c(0.3, 0.4, 0.3)

# Calculate the weighted portfolio returns
weighted_returns <- portfolio_returns * weights

# Calculate the cumulative returns of the portfolio
cumulative_returns <- cumprod(1 + weighted_returns) - 1

# Plot the cumulative returns
plot(cumulative_returns, main = "Portfolio Cumulative Returns", ylab = "Cumulative Returns")

# Calculate and print the final portfolio return
final_return <- cumulative_returns[length(cumulative_returns)]
print(paste("Final portfolio return:", final_return))
