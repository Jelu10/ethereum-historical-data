# Ethereum Historical Data

A historical Ethereum dataset containing normalized decentralized exchange trades and ERC-20 transfers extracted directly from Ethereum mainnet logs.

The dataset is intended for quantitative research, on-chain analytics, machine learning, and other applications that require bulk historical Ethereum activity.

This repository contains documentation, schemas, and example queries for working with the dataset. A sample of the data is provided in Apache Parquet format.


## Download Sample Data

- [DEX trades — ~25 MB](https://github.com/Jelu10/ethereum-historical-data/releases/download/sample-v1.0/dex_trades_sample.parquet)
- [ERC-20 transfers — ~500 MB](https://github.com/Jelu10/ethereum-historical-data/releases/download/sample-v1.0/erc20_transfers_sample.parquet)

Both files cover Ethereum blocks 24,800,000–24,850,000 and are
ZSTD-compressed Apache Parquet files.


## Dataset

The full dataset currently covers Ethereum mainnet from genesis through approximately block **25,000,000**.

Currently available data:

| Dataset          | Description                                |
| ---------------- | ------------------------------------------ |
| DEX Trades       | Normalized Uniswap V2 and Uniswap V3 swaps |
| ERC-20 Transfers | ERC-20 `Transfer` events                   |

DEX trades from different supported protocols are converted into a common representation containing the pool, input/output tokens, and raw input/output amounts.

The full historical dataset contains billions of records.

## Sample Data

The public sample covers:

```text
24,800,000 <= block_number < 24,850,000
```

The sample contains approximately:

* **1.1 million DEX trades**
* ERC-20 transfers from the same block range
* approximately **530 MB** of compressed Parquet data in total

Both files cover the same block interval, making it possible to analyze and join trade and transfer activity over the same section of Ethereum history.

### Files

```text
dex_trades_sample.parquet
erc20_transfers_sample.parquet
```

The Parquet files are available from the repository's release assets.

## Schemas

Detailed column definitions and binary encodings are documented in:

```text
schemas/dex_trades.md
schemas/erc20_transfers.md
```

Ethereum addresses are stored as raw 20-byte values rather than hexadecimal strings.

Raw token amounts are stored as unsigned 256-bit integers using big-endian byte order (most significant byte first). Amounts are intentionally not converted to floating-point values, preserving the original on-chain integer representation.

## Querying the Data

The Parquet files can be queried directly using tools such as DuckDB, Polars, PyArrow, Pandas, Spark, or other Parquet-compatible analytical tools.

For example, with DuckDB:

```sql
SELECT COUNT(*)
FROM read_parquet('dex_trades_sample.parquet');
```

Inspect several trades:

```sql
SELECT *
FROM read_parquet('dex_trades_sample.parquet')
LIMIT 10;
```

Query a block range:

```sql
SELECT *
FROM read_parquet('dex_trades_sample.parquet')
WHERE block_number >= 24810000
  AND block_number < 24811000
ORDER BY block_number, log_index;
```

Additional examples are available in:

```text
examples/duckdb_queries.sql
```

## Data Generation

The dataset is generated directly from Ethereum mainnet data using a custom ingestion and decoding pipeline.

The pipeline processes Ethereum blocks and transaction receipts, extracts relevant event logs, decodes supported protocol events, and converts them into normalized records.

For DEX trades, the currently supported protocols are:

| Protocol ID | Protocol   |
| ----------: | ---------- |
|         `0` | Uniswap V2 |
|         `1` | Uniswap V3 |

## Known Limitations

The current DEX dataset focuses on Uniswap V2 and Uniswap V3.

Malformed events and swaps that cannot be represented by the current normalized trade model are excluded.

Token amounts are provided as raw integer values. Token metadata such as decimals, symbols, and names is not currently included in the public sample.

Additional protocols and derived datasets may be added in the future.

## Full Dataset and Custom Extracts

The public files are a sample of a substantially larger historical dataset.

Larger historical ranges and custom extracts can be provided depending on the use case. If you are working on quantitative research, blockchain analytics, machine learning, DeFi research, or another data-intensive Ethereum application and need a particular subset of the data, feel free to get in touch.

**Contact:** [ethereumhistoricaldata@proton.me](mailto:ethereumhistoricaldata@proton.me)


## Repository Structure

```text
.
├── README.md
├── schemas/
│   ├── dex_trades.md
│   └── erc20_transfers.md
├── examples/
│   └── duckdb_queries.sql
└── .gitignore
```
