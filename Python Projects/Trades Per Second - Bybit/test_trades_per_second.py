import pandas as pd
import bybit

symbol = "BTCUSD"

client = bybit.bybit(test=False, api_key="", api_secret="")

while 1: 
    df = pd.DataFrame.from_dict(client.Market.Market_tradingRecords(symbol=symbol).result()[0]["result"])

    df = df.drop(["id", "symbol", "qty", "side", "price"], axis = 1)
    df["timestamp"] = df["time"].str[:-5]
    df["trades/second"] = ""
    df = df.drop(["time"], axis = 1)
    df = df.groupby(by="timestamp").count()
    df = df.sort_values(by=["timestamp"], ascending = False)
    print (df[:10])
