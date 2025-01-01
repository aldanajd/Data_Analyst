import random

def simulate_martingale(initial_bet, target_profit, max_losses=10):
  """
  Simulates the Martingale betting system.

  Args:
    initial_bet: The initial bet amount.
    target_profit: The desired profit amount.
    max_losses: The maximum number of consecutive losses allowed.

  Returns:
    A tuple containing:
      - True if the target profit is reached, False otherwise.
      - The total number of bets placed.
      - The final bet amount. 
  """
  current_bet = initial_bet
  total_profit = 0
  consecutive_losses = 0
  num_bets = 0

  while total_profit < target_profit and consecutive_losses < max_losses:
    # Simulate a coin flip (replace with your own game logic)
    result = random.choice([True, False])  # True for win, False for loss

    num_bets += 1

    if result:
      total_profit += current_bet
      current_bet = initial_bet  # Reset bet after a win
      consecutive_losses = 0 
    else:
      total_profit -= current_bet
      current_bet *= 2
      consecutive_losses += 1

  return total_profit >= target_profit, num_bets, current_bet

# Example usage:
initial_bet = 1
target_profit = 10
max_losses = 5 

success, num_bets, final_bet = simulate_martingale(initial_bet, target_profit, max_losses)

if success:
  print("Target profit reached!")
  print(f"Number of bets placed: {num_bets}")
  print(f"Final bet amount: {final_bet}") 
else:
  print("Failed to reach target profit within the loss limit.") 