# Problem-89-Gallios-Field-Multiplier
## Definition
```text
A Galois field is a special set of numbers where you can add and multiply,
and the answer always stays inside the same set. For GF(2⁸), that means
every answer fits in 8 bits. Addition is just XOR. Multiplication is shift
and XOR, with a special fix-up step when the number gets too big.
```
### Explaination
#### 1. Normal Multiplication has a problem
``` text
If you multiply two 8-bit numbers, the answer can need 16 bits. In a Galois
 field, the answer is always squeezed back into 8 bits, and no information
is lost.
```

#### 2. Addition is XOR
``` text
There is no carry. 1 + 1 = 0. So adding two numbers is just XOR
```
#### 3. Multiplication is shift and XOR
``` text
Shift left = multiply by 2
If the bit of b is 1, XOR a into the answer
Repeat for all 8 bits
```

#### 4. The fix-up step
``` text
When shifting left pushes a 1 off the top, we can’t just throw it away.
 We XOR with a fixed number (0x1D for our polynomial).
This is the “wrap around”, like a clock going from 12 back to 0.
```


## Example 1 (Without Overflow) 
# Example 1: GF(2⁸) Multiplication Without Overflow

**Problem:** compute `0x03 × 0x05` in GF(2⁸)

**Polynomial:** x⁸ + x⁴ + x³ + x² + 1 (`0x11D`), so the fix-up constant is `0x1D`

---

## Table of Contents

- [Setup](#setup)
- [The 3 rules (every round)](#the-3-rules-every-round)
- [Round by round](#round-by-round)
- [Summary table](#summary-table)
- [Result](#result)
- [Check by hand](#check-by-hand)
- [Why no overflow?](#why-no-overflow)

---

## Setup

```
a = 0000 0011   (0x03)   shifts LEFT each round
b = 0000 0101   (0x05)   shifts RIGHT each round
p = 0000 0000   (0x00)   the answer, built up round by round
```

---

## The 3 rules (every round)

1. If the **last bit of `b`** is 1, then `p = p XOR a`
2. **Shift `a` left.** If a 1 falls off the top, XOR with `0001 1101` (`0x1D`)
3. **Shift `b` right**

---

## Round by round

### Round 0

```
last bit of b = 1   →  ADD

p = 0000 0000
  ^ 0000 0011
  -----------
p = 0000 0011   (0x03)

a:  0000 0011  →  0000 0110   (top bit was 0, no overflow)
b:  0000 0101  →  0000 0010
```

### Round 1

```
last bit of b = 0   →  SKIP

p = 0000 0011   (unchanged)

a:  0000 0110  →  0000 1100   (top bit was 0, no overflow)
b:  0000 0010  →  0000 0001
```

### Round 2

```
last bit of b = 1   →  ADD

p = 0000 0011
  ^ 0000 1100
  -----------
p = 0000 1111   (0x0F)

a:  0000 1100  →  0001 1000   (top bit was 0, no overflow)
b:  0000 0001  →  0000 0000
```

### Rounds 3 to 7

```
b = 0000 0000   →  last bit is always 0  →  SKIP

p = 0000 1111   (stays 0x0F)
```

`b` is all zeros now, so nothing more is added. `a` keeps shifting, but it no longer affects `p`.

---

## Summary table

| Round | Last bit of `b` | Action | `p` after | `a` after shift | `b` after shift |
|-------|-----------------|--------|-----------|-----------------|-----------------|
| 0 | 1 | add | `0000 0011` | `0000 0110` | `0000 0010` |
| 1 | 0 | skip | `0000 0011` | `0000 1100` | `0000 0001` |
| 2 | 1 | add | `0000 1111` | `0001 1000` | `0000 0000` |
| 3 to 7 | 0 | skip | `0000 1111` | n/a | `0000 0000` |

---

## Result

```
p = 0000 1111 = 0x0F
```

**`0x03 × 0x05 = 0x0F`**

---

## Check by hand

- `0x03` = x + 1
- `0x05` = x² + 1
- (x + 1)(x² + 1) = x³ + x² + x + 1 = `0000 1111` = **`0x0F`** ✔

The highest power is x³, which fits easily in 8 bits, so no reduction is needed.

---

## Why no overflow?

The `0x1D` fix-up happens only when a 1 falls off the top of `a` **in a round where it matters**.

- In rounds 0, 1, and 2, `a` is `03`, `06`, `0C`. Bit 7 is 0 each time, so the shift is a plain shift.
- Those are the only rounds where `b` still has bits left to use. After round 2, `b` is zero.
- In later rounds, `a` keeps doubling and will eventually hit the top bit. But `b` is zero by then, so nothing is added to `p`, and the answer does not change.

**Rule of thumb:** if the product's highest power stays below x⁸, no reduction is needed.

Next: see [the overflow example](EXAMPLE_2_OVERFLOW.md) (`0x80 × 0x05`), where the `0x1D` fix-up changes the answer.
