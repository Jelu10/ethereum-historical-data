-- Ethereum Historical Data
-- Example DuckDB queries
-------------------------

-- Run interactively:
--   duckdb
-----------

-- Or execute this file:
--   duckdb < examples/duckdb_queries.sql

-- ============================================================
-- DEX TRADES
-- ============================================================

-- Inspect the schema.
DESCRIBE
SELECT *
FROM read_parquet('dex_trades_sample.parquet');

-- Count trades.
SELECT COUNT(*) AS trade_count
FROM read_parquet('dex_trades_sample.parquet');

-- Inspect the first 10 trades.
SELECT *
FROM read_parquet('dex_trades_sample.parquet')
ORDER BY block_number, log_index
LIMIT 10;

-- Determine the covered block range.
SELECT
MIN(block_number) AS first_block,
MAX(block_number) AS last_block,
COUNT(*) AS trades
FROM read_parquet('dex_trades_sample.parquet');

-- Count trades by protocol.
-- protocol = 0: Uniswap V2
-- protocol = 1: Uniswap V3
SELECT
protocol,
COUNT(*) AS trades
FROM read_parquet('dex_trades_sample.parquet')
GROUP BY protocol
ORDER BY protocol;

-- Trades within a smaller block range.
SELECT *
FROM read_parquet('dex_trades_sample.parquet')
WHERE block_number >= 24810000
AND block_number < 24811000
ORDER BY block_number, log_index;

-- Most active pools by number of trades.
SELECT
hex(pool) AS pool,
COUNT(*) AS trades
FROM read_parquet('dex_trades_sample.parquet')
GROUP BY pool
ORDER BY trades DESC
LIMIT 20;

-- ============================================================
-- ERC-20 TRANSFERS
-- ============================================================

-- Inspect the schema.
DESCRIBE
SELECT *
FROM read_parquet('erc20_transfers_sample.parquet');

-- Count transfers.
SELECT COUNT(*) AS transfer_count
FROM read_parquet('erc20_transfers_sample.parquet');

-- Inspect the first 10 transfers.
SELECT *
FROM read_parquet('erc20_transfers_sample.parquet')
ORDER BY block_number, log_index
LIMIT 10;

-- Determine the covered block range.
SELECT
MIN(block_number) AS first_block,
MAX(block_number) AS last_block,
COUNT(*) AS transfers
FROM read_parquet('erc20_transfers_sample.parquet');

-- Most frequently transferred token contracts.
SELECT
hex(token) AS token,
COUNT(*) AS transfers
FROM read_parquet('erc20_transfers_sample.parquet')
GROUP BY token
ORDER BY transfers DESC
LIMIT 20;

-- Most active senders.
SELECT
hex(sender) AS sender,
COUNT(*) AS transfers
FROM read_parquet('erc20_transfers_sample.parquet')
GROUP BY sender
ORDER BY transfers DESC
LIMIT 20;

-- ============================================================
-- TRADES + TRANSFERS
-- ============================================================

-- Example: count trades and transfers by block.
WITH trades AS (
SELECT
block_number,
COUNT(*) AS trade_count
FROM read_parquet('dex_trades_sample.parquet')
GROUP BY block_number
),
transfers AS (
SELECT
block_number,
COUNT(*) AS transfer_count
FROM read_parquet('erc20_transfers_sample.parquet')
GROUP BY block_number
)
SELECT
COALESCE(t.block_number, e.block_number) AS block_number,
COALESCE(t.trade_count, 0) AS trades,
COALESCE(e.transfer_count, 0) AS transfers
FROM trades t
FULL OUTER JOIN transfers e
ON t.block_number = e.block_number
ORDER BY block_number
LIMIT 100;
