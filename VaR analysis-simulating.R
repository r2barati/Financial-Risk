# Load required libraries
library(quantmod)
library(PerformanceAnalytics)

# Set the start and end dates for backtesting historical data
start_date <- as.Date("2010-01-01")
end_date <- as.Date("2020-12-31")

# Set the start and end dates for future risk testing
future_start_date <- as.Date("2021-01-01")
future_end_date <- as.Date("2023-12-31")

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

# Calculate the portfolio volatility
portfolio_volatility <- sd(weighted_returns) * sqrt(252)  # Assuming 252 trading days in a year

# Perform VaR (Value at Risk) analysis
portfolio_value <- 1000000  # Initial portfolio value
portfolio_loss <- portfolio_value * (1 - (1 + weighted_returns))  # Calculate the daily portfolio losses
portfolio_var <- quantile(portfolio_loss, probs = 0.05)  # Calculate the VaR at 95% confidence level

# Perform maximum drawdown analysis
portfolio_drawdown <- maxDrawdown(cumulative_returns)

# Calculate and print the final portfolio return
final_return <- cumulative_returns[length(cumulative_returns)]
print(paste("Final portfolio return:", final_return))

# Perform risk testing for the future period
future_dates <- seq(future_start_date, future_end_date, by = "days")
future_portfolio <- NULL

for (date in future_dates) {
  # Retrieve the closing prices for the date
  prices <- as.numeric(Ad(getSymbols(tickers, from = date, to = date, auto.assign = FALSE)))

  # Calculate the future portfolio value
  future_portfolio_value <- sum(weights * prices)

  # Append the future portfolio value to the dataframe
  future_portfolio <- rbind(future_portfolio, data.frame(Date = date, Value = future_portfolio_value))
}

# Plot the future portfolio values
plot(future_portfolio$Date, future_portfolio$Value, type = "l", main = "Future Portfolio Values", 
     xlab = "Date", ylab = "Portfolio Value")

# Perform risk testing on the future portfolio values
future_portfolio_returns <- diff(log(future_portfolio$Value))
future_portfolio_volatility <- sd(future_portfolio_returns) * sqrt(252)
future_portfolio_var <- quantile(-future_portfolio_returns, probs = 0.05)

# Print the risk testing results for the future period
print(paste("Future Portfolio Volatility:", future_portfolio_volatility))
print(paste("Future Portfolio VaR (95% confidence level):", future_portfolio_var))
