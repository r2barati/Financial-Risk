import pandas as pd
import yfinance as yf
import matplotlib.pyplot as plt

# Set the start and end dates for backtesting
start_date = "2010-01-01"
end_date = "2020-12-31"

# Define the ticker symbols for the securities in the portfolio
tickers = ["AAPL", "GOOG", "MSFT"]

# Download historical data for each ticker
portfolio_data = yf.download(tickers, start=start_date, end=end_date)["Adj Close"]

# Calculate the daily returns of the portfolio
portfolio_returns = portfolio_data.pct_change()

# Define the portfolio weights (e.g., 30% AAPL, 40% GOOG, 30% MSFT)
weights = [0.3, 0.4, 0.3]

# Calculate the weighted portfolio returns
weighted_returns = portfolio_returns * weights

# Calculate the cumulative returns of the portfolio
cumulative_returns = (1 + weighted_returns).cumprod() - 1

# Plot the cumulative returns
cumulative_returns.plot(title="Portfolio Cumulative Returns")
plt.ylabel("Cumulative Returns")
plt.show()

# Calculate and print the final portfolio return
final_return = cumulative_returns.iloc[-1]
print("Final portfolio return:", final_return)
