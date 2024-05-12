import yfinance as yf
from typing import Union
from pydantic import BaseModel
from fastapi import FastAPI
from typing import Union, List, Optional
import pandas as pd

app = FastAPI()


class InvokeRequest(BaseModel):
    symbol: str
    method: str
    # Optional params list of ints or strings, defaults to None
    params: dict = None

    model_config = {
        "json_schema_extra": {
            "examples": [
                {
                    "symbol": "MSFT",
                    "method": "info"
                },
                {
                    "symbol": "AAPL",
                    "method": "history",
                    "params": {
                        "period": "1m",
                    }
                }
            ]
        }
    }


@app.get("/")
def read_root():
    # read version from file
    version = None
    with open('last-release-version.txt') as f:
        version = f.read().strip()

    yfinanceVersion = yf.__version__
    return {"hello": "world", "version": version if version else "unknown", "now": pd.Timestamp.now(), "yfinanceVersion": yfinanceVersion}


@app.post("/api/invoke/ticker")
def read_item(request: InvokeRequest):
    ticker = yf.Ticker(request.symbol)
    method = getattr(ticker, request.method)
    if method is None:
        return {"error": "Method not found"}
    if isinstance(method, dict):
        return method
    else:
        result = method(**request.params)
        if isinstance(result, pd.DataFrame):
            print('here')
            return result.to_dict()
        else:
            return result
