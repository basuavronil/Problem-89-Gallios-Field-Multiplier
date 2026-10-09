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
