# 8-bit ALU Design and Verification using Verilog

An 8-bit Arithmetic Logic Unit (ALU) designed using **Verilog HDL**, simulated with **Icarus Verilog**, verified using directed and random testbenches, and synthesized using **Yosys**.

This project demonstrates the fundamentals of **RTL Design, Functional Simulation, Digital Logic Design, and Design Verification**.

## Project Overview

An **Arithmetic Logic Unit (ALU)** is a fundamental component of a processor. It performs arithmetic and logical operations on binary data.

In this project, I designed an **8-bit ALU** that takes two 8-bit inputs (`A` and `B`) and a 3-bit operation selector (`opcode`). Based on the selected opcode, the ALU performs one of eight operations and produces an 8-bit result along with status flags.

### Key Features

- 8-bit input and output data width.
- Supports 8 arithmetic and logical operations.
- Implements Carry, Zero, and Overflow flags.
- Combinational logic design using Verilog HDL.
- Self-checking directed testbench with 18 test cases.
- Random verification with 1,000 test cases.
- Functional simulation using Icarus Verilog.
- Waveform analysis using GTKWave.
- Logic synthesis and schematic generation using Yosys.

## ALU Architecture

The ALU has three inputs and four outputs.

### Inputs

| Signal | Width | Description |
|---|---:|---|
| `A` | 8-bit | First input operand |
| `B` | 8-bit | Second input operand |
| `opcode` | 3-bit | Selects the operation to perform |

### Outputs

| Signal | Width | Description |
|---|---:|---|
| `result` | 8-bit | Result of the selected operation |
| `carry` | 1-bit | Indicates carry or subtraction no-borrow status |
| `zero` | 1-bit | Set to 1 when the result is zero |
| `overflow` | 1-bit | Indicates signed arithmetic overflow |

## Supported ALU Operations

The 3-bit opcode selects one of eight operations.

| Opcode | Operation | Verilog Expression | Description |
|---|---|---|---|
| `000` | Addition | `A + B` | Adds two 8-bit numbers |
| `001` | Subtraction | `A - B` | Subtracts B from A |
| `010` | AND | `A & B` | Performs bitwise AND |
| `011` | OR | `A \| B` | Performs bitwise OR |
| `100` | XOR | `A ^ B` | Performs bitwise XOR |
| `101` | NOT | `~A` | Inverts all bits of A |
| `110` | Left Shift | `A << 1` | Shifts A one bit to the left |
| `111` | Right Shift | `A >> 1` | Shifts A one bit to the right |

## Status Flags

The ALU generates three status flags to provide additional information about the operation.

**1. Carry Flag**

- During addition, `carry = 1` when the result exceeds the 8-bit unsigned range (255).
- During subtraction, `carry = 1` when `A >= B`, meaning no borrow occurred.
- For the other operations, the carry flag remains 0.

**2. Zero Flag**

- `zero = 1` when the 8-bit result is `00000000`.
- Otherwise, `zero = 0`.
- This flag is evaluated after every operation.

**3. Overflow Flag**

- Indicates signed arithmetic overflow in addition and subtraction.
- For addition, overflow occurs when two operands with the same sign produce a result with a different sign.
- For subtraction, overflow occurs when operands with different signs produce a result whose sign differs from A.
- For logical and shift operations, the overflow flag remains 0.

## Project Directory Structure

```text
01_8bit_alu/
│
├── rtl/
│   └── alu.v
│
├── testbench/
│   ├── alu_tb.v
│   └── alu_random_tb.v
│
├── simulation/
│   ├── alu.vcd
│   └── alu_random.vcd
│
├── reports/
│   ├── alu_schematic.dot
│   ├── alu_schematic.png
│   ├── synthesis_report.txt
│   └── alu_synth.v
│
└── README.md
```

**Folder and File Description**

| File / Folder | Purpose |
|---|---|
| `rtl/alu.v` | Main ALU RTL implementation |
| `testbench/alu_tb.v` | Directed self-checking testbench |
| `testbench/alu_random_tb.v` | Random verification testbench |
| `simulation/` | Stores simulation waveform files |
| `reports/alu_schematic.png` | Synthesized logic schematic |
| `reports/alu_schematic.dot` | Graphviz schematic source |
| `reports/synthesis_report.txt` | Yosys synthesis statistics |
| `reports/alu_synth.v` | Synthesized Verilog netlist |

## Design Implementation

The ALU is implemented as a combinational logic circuit using Verilog HDL.

The main RTL module uses:

- `module` to define the ALU.
- `input` and `output` ports for signal connections.
- `always @(*)` to describe combinational logic.
- `case` statements to select operations based on the opcode.
- Default assignments to ensure all outputs have defined values and avoid unintended latch inference.

The design does not use a clock signal because all operations are performed using combinational logic.

## Verification and Testing

Verification is an essential part of digital design. The ALU was tested using two different testbenches.

### 1. Directed Testing

The directed testbench (`alu_tb.v`) contains **18 predefined test cases**.

Each test provides:
- Input A
- Input B
- Opcode
- Expected result
- Expected status flags

The testbench compares the expected outputs with the actual ALU outputs.

It automatically reports **PASS** when all outputs match and **FAIL** when any output differs.

The test cases cover:

- All eight ALU operations.
- Normal addition and subtraction.
- Unsigned carry and subtraction borrow conditions.
- Signed overflow conditions.
- Zero-result conditions.
- Logical operation results.
- Left and right shift boundary cases.

**Directed Test Results**

| Metric | Result |
|---|---:|
| Total Test Cases | 18 |
| Passed | 18 |
| Failed | 0 |
| Status | ALL PASSED |

### 2. Random Testing

The random testbench (`alu_random_tb.v`) generates different input combinations and operation codes using Verilog's `$random` function.

It performs **1,000 randomized test iterations**.

For every iteration, the testbench:
1. Generates random values for A and B.
2. Selects a random opcode.
3. Calculates the expected output.
4. Compares the expected output with the actual ALU output.
5. Records the test result.

**Random Test Results**

| Metric | Result |
|---|---:|
| Total Test Cases | 1,000 |
| Passed | 1,000 |
| Failed | 0 |
| Status | ALL PASSED |

**Combined Verification Summary**

| Verification Type | Total Tests | Passed | Failed |
|---|---:|---:|---:|
| Directed Testing | 18 | 18 | 0 |
| Random Testing | 1,000 | 1,000 | 0 |
| **Total** | **1,018** | **1,018** | **0** |

All 1,018 executed test cases passed successfully.

*Note: These are directed and randomized tests, not exhaustive verification of all possible input combinations.*

## Simulation and Waveform Analysis

**Icarus Verilog** was used to compile and simulate the RTL design with the testbenches.

The simulation generates VCD (Value Change Dump) files containing signal changes over time.

**GTKWave** was used to inspect the waveforms and observe how input signals, opcode, result, and status flags change during simulation.

### Run Directed Simulation

```bash
iverilog -o simulation/alu_sim rtl/alu.v testbench/alu_tb.v
vvp simulation/alu_sim
```

### Run Random Simulation

```bash
iverilog -o simulation/alu_random_sim rtl/alu.v testbench/alu_random_tb.v
vvp simulation/alu_random_sim
```

### Open Waveforms

```bash
gtkwave simulation/alu.vcd
```

For random test waveforms:

```bash
gtkwave simulation/alu_random.vcd
```

## Logic Synthesis and Schematic Generation

**Yosys** was used to synthesize the Verilog RTL design and generate a logic schematic.

The synthesis process converts the behavioral RTL description into a lower-level representation of hardware logic.

### Synthesis Command

```bash
yosys -p "read_verilog rtl/alu.v; hierarchy -top alu; synth -top alu; stat; write_verilog reports/alu_synth.v" | tee reports/synthesis_report.txt
```

This process performs:

- Verilog source reading.
- Module hierarchy checking.
- Logic synthesis.
- Optimization.
- Cell statistics reporting.
- Synthesized Verilog netlist generation.

### Schematic Generation

```bash
yosys -p "read_verilog rtl/alu.v; hierarchy -top alu; proc; opt; show -format png -prefix reports/alu_schematic"
```

The generated schematic is available at:

`reports/alu_schematic.png`

## Tools and Technologies

| Tool / Technology | Purpose |
|---|---|
| Verilog HDL | RTL design implementation |
| Icarus Verilog | Functional simulation |
| GTKWave | Waveform visualization |
| Yosys | Logic synthesis and analysis |
| VS Code | Code editing |
| Git & GitHub | Version control and project hosting |

## How to Run the Project

### Prerequisites

Install the following tools:

- Icarus Verilog
- GTKWave
- Yosys
- Git

### Clone the Repository

```bash
git clone git@github.com:Shihab-004/chip_shihab.git
```

Navigate to the project directory:

```bash
cd chip_shihab/01_8bit_alu
```

*Adjust the directory path if you have placed the project at the repository root.*

### Run the Testbenches

For directed testing:

```bash
iverilog -o simulation/alu_sim rtl/alu.v testbench/alu_tb.v
vvp simulation/alu_sim
```

For random testing:

```bash
iverilog -o simulation/alu_random_sim rtl/alu.v testbench/alu_random_tb.v
vvp simulation/alu_random_sim
```

## Project Limitations and Future Improvements

This project focuses on combinational RTL design and functional verification.

Possible future improvements include:

- Exhaustive verification of all possible input combinations.
- More independent reference-model-based verification.
- Functional coverage analysis for all operations and important input conditions.
- Parameterized ALU design with configurable data width.
- FPGA implementation and hardware testing.
- Area and timing analysis using a target-specific synthesis flow.

## Learning Outcomes

Through this project, I gained practical experience with:

- Designing combinational digital circuits using Verilog HDL.
- Understanding RTL design concepts.
- Implementing arithmetic and logical operations.
- Handling carry, zero, and signed overflow flags.
- Writing self-checking testbenches.
- Performing directed and randomized functional verification.
- Analyzing simulation waveforms using GTKWave.
- Synthesizing RTL designs and inspecting hardware logic using Yosys.

## Author

**Shihabul Islam Shihab**

Mechatronics Engineering Student | RUET

GitHub: [Shihab-004](https://github.com/Shihab-004)

---

**Project:** 8-bit ALU Design and Verification using Verilog  
**Status:** RTL Design, Simulation, Directed Testing, Random Testing, and Generic Logic Synthesis Completed.
