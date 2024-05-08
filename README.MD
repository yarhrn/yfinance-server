## yfinance-server

A simple server that fetches stock data from Yahoo Finance and returns it in JSON format
using the [yfinance](https://github.com/ranaroussi/yfinance) library.

Latest release version: `0.10.0`

### How to use

#### Via Docker

```bash
docker run -p 8000.10.00 -d --name yfinance-server yfinance-server:0.10.0
```

#### Via Python

```bash
pip install -r requirements.txt
fastapi dev main.py
```

Open `https://localhost:8000/docs` in your browser to see the API documentation and try out the endpoints.

### Highlevel Architecture

The server is a wrapper around the yfinance library that essentially exposes yfinance methods as API endpoints. So the protocol is rpc like.
To execute request do `POST` request on the endpoint `/api/invoke/ticker` with the following body:

```json
{
  "symbol": "AAPL",
  "method": "history",
  "params": {
    "period": "1d",
    "interval": "1m"
  }
}
```

The server will try to init `yt.Ticker(symbol)` and call `method` with `params` on it. The response will be returned as JSON. More examples can be found by visiting the OpenAPI `/docs` endpoint.

### Release

I will try to release a new version of the server every time a new version of the yfinance library is released.
To check which version of yfinance is used in the server, you can visit the `/api/version` endpoint or check the CHANGELOG.md file.

I will try to follow the [Semantic Versioning](https://semver.org/) guidelines when releasing new versions but I can't guarantee that I will always follow them.


### Disclaimer
This software is provided as is and I am not responsible for any damages that may occur from using it. Use at your own risk.