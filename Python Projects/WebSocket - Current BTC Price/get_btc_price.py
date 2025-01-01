import json
import websocket

# Coinbase Pro WebSocket URL for public data
websocket_url = 'wss://ws-feed.exchange.coinbase.com'

# Function to create a Coinbase Pro WebSocket subscription message
def create_subscription(product_id):
    return {
        "type": "subscribe",
        "product_ids": [product_id],
        "channels": ["ticker"]
    }

# Function to handle incoming WebSocket messages
def on_message(ws, message):
    data = json.loads(message)
    if 'ticker' in data['type']:
        print(f"Received Ticker Update: {data['product_id']} - Price: {data['price']}")

# Create WebSocket connection
ws = websocket.WebSocketApp(websocket_url, on_message=on_message)

# Subscribe to the BTC-USD pair
subscription_message = create_subscription("BTC-USD")
ws.on_open = lambda ws: ws.send(json.dumps(subscription_message))

# Run WebSocket indefinitely
ws.run_forever()