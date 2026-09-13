# ERC-20 Transfers Schema

ERC-20 `Transfer` events extracted from Ethereum logs.

| Column         | Type     | Description                                                                                             |
| -------------- | -------- | ------------------------------------------------------------------------------------------------------- |
| `block_number` | `BIGINT` | Ethereum block number containing the transfer.                                                          |
| `log_index`    | `BIGINT` | Log index within the block. Together with `block_number`, this uniquely identifies the originating log. |
| `token`        | `BLOB`   | 20-byte address of the ERC-20 token contract.                                                           |
| `sender`       | `BLOB`   | 20-byte address of the sender.                                                                          |
| `recipient`    | `BLOB`   | 20-byte address of the recipient.                                                                       |
| `amount`       | `BLOB`   | Raw unsigned ERC-20 token amount before decimal normalization.                                          |

## Binary encoding

Ethereum addresses are stored as raw 20-byte binary values rather than hexadecimal strings.

`amount` is stored as a raw unsigned 256-bit integer. The byte order is big-endian.

Token amounts can be converted to human-readable form using the token's `decimals` metadata:

```text
human_amount = raw_amount / 10^decimals
```

## Ordering

Rows are ordered by:

```text
(block_number, log_index)
```
