## yfinance-server

A simple server that fetches stock data from Yahoo Finance and returns it in JSON format
using the [yfinance](https://github.com/ranaroussi/yfinance) library.

Latest release version: `0.0.1`

### How to use

#### Via Docker

```bash
docker pull yarhrn/yfinance-server:latest
docker run -p 8000:8000 -d --name yfinance-server yarhrn/yfinance-server:latest
```

#### Via Python

```bash
pip install -r requirements.txt
fastapi dev main.py
```

Open `https://localhost:8000/docs` in your browser to see the API documentation and try out the endpoints.

### API KEY support
To protect invoke request from unauthorized access, you can set an API key in the environment variable `API_KEY1` and `API_KEY2`(for rotation support).
The server will check the `X-API-KEY` header in the request and compare it with the environment variable. If the keys match, the request will be processed, otherwise, the server will return a 401 status code.

```bash
docker pull yarhrn/yfinance-server:latest
docker run -p 8000:8000 -d --name yfinance-server -e API_KEY1=somekey yarhrn/yfinance-server:latest

```


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

### Request Examples
#### Get info about a ticker
```json
{
  "symbol": "AAPL",
  "method": "info",
  "params": {}
}
```

<details>
  <summary>Response</summary>

  ```js
{
  "address1": "One Apple Park Way",
  "city": "Cupertino",
  "state": "CA",
  "zip": "95014",
  "country": "United States",
  "phone": "408 996 1010",
  "website": "https://www.apple.com",
  "industry": "Consumer Electronics",
  "industryKey": "consumer-electronics",
  "industryDisp": "Consumer Electronics",
  "sector": "Technology",
  "sectorKey": "technology",
  "sectorDisp": "Technology",
  "longBusinessSummary": "Apple Inc. designs, manufactures, and markets smartphones, personal computers, tablets, wearables, and accessories worldwide. The company offers iPhone, a line of smartphones; Mac, a line of personal computers; iPad, a line of multi-purpose tablets; and wearables, home, and accessories comprising AirPods, Apple TV, Apple Watch, Beats products, and HomePod. It also provides AppleCare support and cloud services; and operates various platforms, including the App Store that allow customers to discover and download applications and digital content, such as books, music, video, games, and podcasts. In addition, the company offers various services, such as Apple Arcade, a game subscription service; Apple Fitness+, a personalized fitness service; Apple Music, which offers users a curated listening experience with on-demand radio stations; Apple News+, a subscription news and magazine service; Apple TV+, which offers exclusive original content; Apple Card, a co-branded credit card; and Apple Pay, a cashless payment service, as well as licenses its intellectual property. The company serves consumers, and small and mid-sized businesses; and the education, enterprise, and government markets. It distributes third-party applications for its products through the App Store. The company also sells its products through its retail and online stores, and direct sales force; and third-party cellular network carriers, wholesalers, retailers, and resellers. Apple Inc. was founded in 1976 and is headquartered in Cupertino, California.",
  "fullTimeEmployees": 150000,
  "companyOfficers": [
    {
      "maxAge": 1,
      "name": "Mr. Timothy D. Cook",
      "age": 62,
      "title": "CEO & Director",
      "yearBorn": 1961,
      "fiscalYear": 2023,
      "totalPay": 16239562,
      "exercisedValue": 0,
      "unexercisedValue": 0
    },
    {
      "maxAge": 1,
      "name": "Mr. Luca  Maestri",
      "age": 60,
      "title": "CFO & Senior VP",
      "yearBorn": 1963,
      "fiscalYear": 2023,
      "totalPay": 4612242,
      "exercisedValue": 0,
      "unexercisedValue": 0
    },
    {
      "maxAge": 1,
      "name": "Mr. Jeffrey E. Williams",
      "age": 59,
      "title": "Chief Operating Officer",
      "yearBorn": 1964,
      "fiscalYear": 2023,
      "totalPay": 4637585,
      "exercisedValue": 0,
      "unexercisedValue": 0
    },
    {
      "maxAge": 1,
      "name": "Ms. Katherine L. Adams",
      "age": 59,
      "title": "Senior VP, General Counsel & Secretary",
      "yearBorn": 1964,
      "fiscalYear": 2023,
      "totalPay": 4618064,
      "exercisedValue": 0,
      "unexercisedValue": 0
    },
    {
      "maxAge": 1,
      "name": "Ms. Deirdre  O'Brien",
      "age": 56,
      "title": "Senior Vice President of Retail",
      "yearBorn": 1967,
      "fiscalYear": 2023,
      "totalPay": 4613369,
      "exercisedValue": 0,
      "unexercisedValue": 0
    },
    {
      "maxAge": 1,
      "name": "Mr. Chris  Kondo",
      "title": "Senior Director of Corporate Accounting",
      "fiscalYear": 2023,
      "exercisedValue": 0,
      "unexercisedValue": 0
    },
    {
      "maxAge": 1,
      "name": "Mr. James  Wilson",
      "title": "Chief Technology Officer",
      "fiscalYear": 2023,
      "exercisedValue": 0,
      "unexercisedValue": 0
    },
    {
      "maxAge": 1,
      "name": "Suhasini  Chandramouli",
      "title": "Director of Investor Relations",
      "fiscalYear": 2023,
      "exercisedValue": 0,
      "unexercisedValue": 0
    },
    {
      "maxAge": 1,
      "name": "Mr. Greg  Joswiak",
      "title": "Senior Vice President of Worldwide Marketing",
      "fiscalYear": 2023,
      "exercisedValue": 0,
      "unexercisedValue": 0
    },
    {
      "maxAge": 1,
      "name": "Mr. Adrian  Perica",
      "age": 49,
      "title": "Head of Corporate Development",
      "yearBorn": 1974,
      "fiscalYear": 2023,
      "exercisedValue": 0,
      "unexercisedValue": 0
    }
  ],
  "auditRisk": 6,
  "boardRisk": 1,
  "compensationRisk": 2,
  "shareHolderRightsRisk": 1,
  "overallRisk": 1,
  "governanceEpochDate": 1714521600,
  "compensationAsOfEpochDate": 1703980800,
  "irWebsite": "http://investor.apple.com/",
  "maxAge": 86400,
  "priceHint": 2,
  "previousClose": 189.84,
  "open": 189.38,
  "dayLow": 189.22,
  "dayHigh": 190.81,
  "regularMarketPreviousClose": 189.84,
  "regularMarketOpen": 189.38,
  "regularMarketDayLow": 189.22,
  "regularMarketDayHigh": 190.81,
  "dividendRate": 1,
  "dividendYield": 0.0053,
  "exDividendDate": 1715299200,
  "payoutRatio": 0.14930001,
  "fiveYearAvgDividendYield": 0.73,
  "beta": 1.264,
  "trailingPE": 29.482918,
  "forwardPE": 26.26141,
  "volume": 40771639,
  "regularMarketVolume": 40771639,
  "averageVolume": 64275736,
  "averageVolume10days": 58961950,
  "averageDailyVolume10Day": 58961950,
  "bid": 189.81,
  "ask": 189.91,
  "bidSize": 100,
  "askSize": 100,
  "marketCap": 2911485558784,
  "fiftyTwoWeekLow": 164.08,
  "fiftyTwoWeekHigh": 199.62,
  "priceToSalesTrailing12Months": 7.629219,
  "fiftyDayAverage": 174.111,
  "twoHundredDayAverage": 180.77705,
  "trailingAnnualDividendRate": 0.96,
  "trailingAnnualDividendYield": 0.00505689,
  "currency": "USD",
  "enterpriseValue": 2948922081280,
  "profitMargins": 0.26306,
  "floatShares": 15308474083,
  "sharesOutstanding": 15334099968,
  "sharesShort": 94308265,
  "sharesShortPriorMonth": 108782648,
  "sharesShortPreviousMonthDate": 1711584000,
  "dateShortInterest": 1714435200,
  "sharesPercentSharesOut": 0.0062,
  "heldPercentInsiders": 0.052199997,
  "heldPercentInstitutions": 0.57553,
  "shortRatio": 1.66,
  "shortPercentOfFloat": 0.0062,
  "impliedSharesOutstanding": 15467299840,
  "bookValue": 4.837,
  "priceToBook": 39.25367,
  "lastFiscalYearEnd": 1696032000,
  "nextFiscalYearEnd": 1727654400,
  "mostRecentQuarter": 1711756800,
  "earningsQuarterlyGrowth": -0.022,
  "netIncomeToCommon": 100389003264,
  "trailingEps": 6.44,
  "forwardEps": 7.23,
  "pegRatio": 2.62,
  "lastSplitFactor": "4:1",
  "lastSplitDate": 1598832000,
  "enterpriseToRevenue": 7.727,
  "enterpriseToEbitda": 22.749,
  "52WeekChange": 0.08995402,
  "SandP52WeekChange": 0.26490295,
  "lastDividendValue": 0.25,
  "lastDividendDate": 1715299200,
  "exchange": "NMS",
  "quoteType": "EQUITY",
  "symbol": "AAPL",
  "underlyingSymbol": "AAPL",
  "shortName": "Apple Inc.",
  "longName": "Apple Inc.",
  "firstTradeDateEpochUtc": 345479400,
  "timeZoneFullName": "America/New_York",
  "timeZoneShortName": "EDT",
  "uuid": "8b10e4ae-9eeb-3684-921a-9ab27e4d87aa",
  "messageBoardId": "finmb_24937",
  "gmtOffSetMilliseconds": -14400000,
  "currentPrice": 189.87,
  "targetHighPrice": 250,
  "targetLowPrice": 164,
  "targetMeanPrice": 202.26,
  "targetMedianPrice": 200,
  "recommendationMean": 2.1,
  "recommendationKey": "buy",
  "numberOfAnalystOpinions": 39,
  "totalCash": 67150000128,
  "totalCashPerShare": 4.379,
  "ebitda": 129629003776,
  "totalDebt": 104590000128,
  "quickRatio": 0.875,
  "currentRatio": 1.037,
  "totalRevenue": 381623009280,
  "debtToEquity": 140.968,
  "revenuePerShare": 24.537,
  "returnOnAssets": 0.22073999,
  "returnOnEquity": 1.4725,
  "freeCashflow": 84726874112,
  "operatingCashflow": 110563000320,
  "earningsGrowth": 0.007,
  "revenueGrowth": -0.043,
  "grossMargins": 0.45586,
  "ebitdaMargins": 0.33968,
  "operatingMargins": 0.30743,
  "financialCurrency": "USD",
  "trailingPegRatio": 2.2515
}
  ```
</details>

### Release

I will try to release a new version of the server every time a new version of the yfinance library is released.
To check which version of yfinance is used in the server, you can visit the `/api/version` endpoint or check the CHANGELOG.md file.

I will try to follow the [Semantic Versioning](https://semver.org/) guidelines when releasing new versions but I can't guarantee that I will always follow them.


### Disclaimer
This software is provided as is and I am not responsible for any damages that may occur from using it. Use at your own risk.