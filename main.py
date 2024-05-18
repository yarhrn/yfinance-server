import yfinance as yf
from typing import Annotated, Union
from pydantic import BaseModel
from fastapi import FastAPI, Header, HTTPException
from typing import Union, List, Optional
import pandas as pd
import os

app = FastAPI()

apiKey1 = os.getenv('API_KEY1')
apiKey2 = os.getenv('API_KEY2')
apiKeyPresent = apiKey1 is not None or apiKey2 is not None


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


@app.get("/api/info")
def read_root():
    # read version from file
    version = None
    with open('last-release-version.txt') as f:
        version = f.read().strip()

    yfinanceVersion = yf.__version__
    return {"hello": "world", "version": version if version else "unknown", "now": pd.Timestamp.now(), "yfinanceVersion": yfinanceVersion}


@app.post("/api/invoke/ticker")
def read_item(request: InvokeRequest, x_api_key: Annotated[str | None, Header()] = None):
    if apiKeyPresent:
        if x_api_key is None:
            raise HTTPException(
                status_code=401, detail="API key is missing"
            )
        if x_api_key != apiKey1 and api_key != apiKey2:
            raise HTTPException(
                status_code=403, detail="API key is invalid"
            )
        
        
    ticker = yf.Ticker(request.symbol)
    method = getattr(ticker, request.method, None)
    if method is None:
        raise HTTPException(
            status_code=404, detail="Method not found"
        )
    if isinstance(method, dict):
        return method
    else:
        result = method(**request.params)
        if isinstance(result, pd.DataFrame):
            print('here')
            return result.to_dict()
        else:
            return result
