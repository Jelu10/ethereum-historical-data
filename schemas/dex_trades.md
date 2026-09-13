# DEX Trades Schema

Normalized DEX trades extracted from Ethereum logs.

| Column         | Type     | Description                                                                                        |
| -------------- | -------- | -------------------------------------------------------------------------------------------------- |
| `block_number` | `BIGINT` | Ethereum block number containing the trade.                                                        |
| `log_index`    | `BIGINT` | Log index within the block. Together with `block_number`, uniquely identifies the originating log. |
| `protocol`     | `BIGINT` | DEX protocol identifier. See mapping below.                                                        |
| `pool`         | `BLOB`   | Raw 20-byte Ethereum address of the liquidity pool.                                                |
| `token_in`     | `BLOB`   | Raw 20-byte address of the input token.                                                            |
| `token_out`    | `BLOB`   | Raw 20-byte address of the output token.                                                           |
| `amount_in`    | `BLOB`   | Raw unsigned token amount before decimal normalization.                                            |
| `amount_out`   | `BLOB`   | Raw unsigned token amount before decimal normalization.                                            |

## Protocol identifiers

| Value | Protocol   |
| ----: | ---------- |
|   `0` | Uniswap V2 |
|   `1` | Uniswap V3 |

## Binary encoding

Ethereum addresses are stored as raw 20-byte values, corresponding directly to their hexadecimal representation without the `0x` prefix.

Token amounts are stored as unsigned 256-bit integers using **big-endian byte order (most significant byte first)**.

Human-readable token amounts can be calculated using the token's `decimals` value:

```text
human_amount = raw_amount / 10^decimals
```

## Ordering and uniqueness

Rows are ordered by:

```text
(block_number, log_index)
```

The pair `(block_number, log_index)` uniquely identifies a trade within the dataset.

## Coverage

The current dataset contains normalized **Uniswap V2** and **Uniswap V3** swaps. Malformed or unsupported swap events are excluded.
