# SRAM-FSM-Processing-System

## 6T SRAM Cell Design and FSM-Based Digital SRAM Processing System

This project presents the design, analysis, layout, and verification of an SRAM-based memory system consisting of two major parts:

1. **Analog Design:** Design and analysis of a conventional 6T SRAM cell using Cadence Virtuoso with 45 nm CMOS technology.
2. **Digital Design:** Design and verification of an SRAM-based digital processing system using Verilog HDL and AMD Xilinx Vivado, including an FSM-based controller, ALU, register file, instruction decoder, instruction memory, and SRAM.

The project demonstrates the complete flow from transistor-level SRAM design to RTL-level digital memory integration and verification.

---

# Project Objectives

- Design a conventional 6T SRAM cell using 45 nm CMOS technology.
- Design the physical layout of the 6T SRAM cell using Cadence Layout Design Suite.
- Analyze the SRAM cell for hold, read, and write operations.
- Develop an FSM-based digital controller using Verilog HDL.
- Design and integrate a digital SRAM model with the processing system.
- Implement arithmetic and logical operations using an ALU.
- Verify SRAM data storage and retrieval through simulation.
- Analyze the functionality and performance of the complete digital system.

---

# 1. Analog SRAM Design

## 1.1 6T SRAM Cell

The analog portion of the project implements a conventional **6-transistor (6T) SRAM cell**.

The SRAM cell consists of:

- Two cross-coupled CMOS inverters
- Two access transistors
- Bit Line (BL)
- Complementary Bit Line (BLB)
- Word Line (WL)

The cross-coupled inverters provide the bistable storage mechanism, while the access transistors control the connection between the internal storage nodes and the bit lines.

### Basic 6T SRAM Structure

```text
                 VDD
                  |
             ┌────┴────┐
             │ Inverter│
             └────┬────┘
                  │
                 Q ─────────────┐
                  │             │
             ┌────┴────┐        │
             │ Inverter│        │
             └────┬────┘        │
                  │             │
                 QB ────────────┘

       BL ── Access Transistor ── Q
                    │
                   WL

       BLB ─ Access Transistor ── QB
                    │
                   WL
1.2 Technology
Parameter	Specification
SRAM Type	Conventional 6T SRAM
Technology	45 nm CMOS
Design Tool	Cadence Virtuoso
Layout Tool	Cadence Layout Design Suite
Storage	1 bit per SRAM cell
Access Lines	BL, BLB, WL
2. Analog SRAM Operations
2.1 Hold Operation

During the hold condition:

Word Line (WL) is LOW.
Access transistors are OFF.
The cross-coupled inverters maintain the stored data.
Bit lines are isolated from the storage nodes.

The cell should retain its stored value without disturbance.

2.2 Read Operation

During a read operation:

BL and BLB are precharged.
WL is enabled.
The stored data causes a small voltage difference between BL and BLB.
The differential voltage is used to determine the stored logic value.

The read operation must maintain the stability of the internal storage nodes.

2.3 Write Operation

During a write operation:

The required data and complementary data are applied to BL and BLB.
WL is enabled.
The access transistors connect the bit lines to the internal storage nodes.
The cross-coupled inverters switch to the new state.
WL is disabled and the new data is retained.
3. SRAM Characteristics

The major characteristics considered in the SRAM design include:

Data retention
Read stability
Write ability
Access time
Power consumption
Cell area
Reliability

The 6T SRAM provides a good balance between density, stability, power, and performance, making it a commonly studied SRAM architecture.

4. SRAM Speed

SRAM speed can be evaluated using the time required for a memory cell to respond to a read or write operation.

The important timing parameters include:

Read Access Time

The time between activation of the Word Line and the development of a valid output on the bit lines.

Read Access Time =
Time when data becomes valid
-
Time when read operation begins
Write Time

The time required to force the SRAM cell from its previous state to the desired new state.

Digital SRAM Clock

In the digital Verilog implementation, the simulation uses:

Clock period = 10 ns
Clock frequency = 100 MHz

Therefore:

Frequency = 1 / 10 ns

         = 100 MHz

For the 8-bit SRAM interface, the theoretical data transfer rate for one 8-bit transfer per clock is:

8 bits × 100 MHz
= 800 Mbit/s
= 100 MB/s

This represents the theoretical interface throughput, not the complete instruction execution time, since the processing system requires multiple clock cycles for operations such as instruction fetch, execution, store, and load.

5. Digital SRAM Design

The digital portion of the project models SRAM and a processing system using Verilog HDL.

The system consists of:

                ┌───────────────────────┐
                │ FSM-Based Controller  │
                └───────────┬───────────┘
                            │
          ┌─────────────────┼─────────────────┐
          │                 │                 │
          ▼                 ▼                 ▼
      Register File       ALU              SRAM
          │                 │                 │
          └─────────────────┴─────────────────┘
                            │
                     Data Processing
6. Digital SRAM Specifications

The Verilog SRAM is implemented as:

reg [7:0] memory [0:255];

Therefore:

Parameter	Value
Address Width	8 bits
Data Width	8 bits
Number of Locations	256
Memory Capacity	2048 bits
Memory Capacity	256 bytes
Address Range	0–255
Digital Clock	100 MHz
Memory Capacity
256 locations × 8 bits
= 2048 bits
= 256 bytes
7. Digital System Architecture

The digital processing system contains the following modules:

FSM-Based Controller

Controls the sequence of operations and generates control signals for the memory and processing blocks.

ALU

Performs arithmetic and logical operations.

Implemented operations include:

ADD
SUB
AND
OR
EOR
Increment
Decrement
Pass-through
Register File

The register file provides storage for operands and processed data.

The verification uses:

R16 = 10
R17 = 20
Instruction Decoder

Decodes the instruction and generates:

ALU operation
Register addresses
Immediate data
Register write control
Memory operation information
SRAM

Provides data storage and retrieval.

Program Counter

Controls instruction sequencing.

Instruction Register

Stores the current instruction for decoding and execution.

Instruction Memory

Stores the program instructions used during simulation.

8. FSM-Based Processing Controller

The controller sequences the digital system through different processing stages.

A simplified operation sequence is:

        ┌─────────┐
        │  RESET  │
        └────┬────┘
             ▼
        ┌─────────┐
        │  FETCH  │
        └────┬────┘
             ▼
        ┌─────────┐
        │ DECODE  │
        └────┬────┘
             ▼
        ┌─────────┐
        │ EXECUTE │
        └────┬────┘
             ▼
        ┌─────────┐
        │  STORE  │
        └────┬────┘
             ▼
        ┌─────────┐
        │  LOAD   │
        └────┬────┘
             ▼
        ┌─────────┐
        │ VERIFY  │
        └────┬────┘
             │
             └──────────► FETCH

The FSM generates the required control signals for:

SRAM read
SRAM write
Address selection
Data transfer
ALU operation
Register write
Instruction sequencing
9. ALU Verification

The digital system was verified using two operands:

R16 = 10
R17 = 20

The following operations were performed:

Operation	Operand A	Operand B	ALU Result
ADD	10	20	30
SUB	10	20	246
AND	10	20	0
OR	10	20	30
EOR	10	20	30

For subtraction:

10 - 20 = -10

Since the digital ALU uses 8-bit representation:

-10 = 246 (8-bit unsigned representation)
10. SRAM STORE and LOAD Verification

The ALU results are stored into different SRAM locations.

Operation	SRAM Address	Stored Data	Loaded Data
ADD	SRAM[16]	30	30
SUB	SRAM[17]	246	246
AND	SRAM[18]	0	0
OR	SRAM[19]	30	30
EOR	SRAM[20]	30	30

The successful retrieval of the same data after storage confirms correct SRAM functionality in the RTL simulation.

11. Digital Data Flow

The complete digital processing flow is:

Instruction Memory
        │
        ▼
Instruction Register
        │
        ▼
Instruction Decoder
        │
        ▼
FSM Controller
        │
        ├──────────────► Register File
        │                     │
        │                     ▼
        │                    ALU
        │                     │
        │                     ▼
        └──────────────────► SRAM
                              │
                              ▼
                         Load / Retrieve
12. Verification

The digital design was simulated using AMD Xilinx Vivado.

The simulation verifies:

Instruction execution
Register operations
ALU operations
SRAM write operation
SRAM read operation
Data retention between STORE and LOAD
FSM control sequence

Example verification flow:

LDI R16 ← 10
LDI R17 ← 20

ADD
   ↓
Result = 30
   ↓
STORE → SRAM[16]
   ↓
LOAD ← SRAM[16]
   ↓
30

The same procedure is followed for SUB, AND, OR, and EOR operations.

13. Tools Used
Analog Design
Cadence Virtuoso
Cadence Layout Design Suite
45 nm CMOS Technology
Digital Design
Verilog HDL
AMD Xilinx Vivado
RTL Simulation
Behavioral Simulation
Synthesis
14. Project Structure
SRAM-FSM-Processing-System/
│
├── Analog design/
│   ├── 6T SRAM schematic
│   ├── Layout
│   └── Simulation files
│
├── Digital desgin/
│   ├── Verilog RTL
│   ├── SRAM
│   ├── FSM Controller
│   ├── ALU
│   ├── Register File
│   ├── Instruction Decoder
│   ├── Testbench
│   └── Vivado project
│
└── README.md
15. Key Features
Conventional 6T SRAM cell
45 nm CMOS technology
Transistor-level SRAM design
SRAM layout design
Read, write, and hold analysis
256 × 8-bit digital SRAM
FSM-based processing controller
8-bit ALU
Register file
Instruction decoder
SRAM STORE/LOAD operations
RTL simulation and verification
Cadence and Vivado based design flow
16. Conclusion

This project demonstrates the design of SRAM at both transistor and RTL levels.

The analog section focuses on the design, layout, and analysis of a conventional 6T SRAM cell using 45 nm CMOS technology.

The digital section implements an SRAM-based processing system using Verilog HDL. An FSM-based controller coordinates instruction processing, ALU operations, register transfers, and SRAM read/write operations.

The complete digital system was verified through simulation using arithmetic and logical operations, followed by SRAM storage and retrieval.

The project provides practical exposure to both VLSI memory-cell design and RTL-based digital system design and verification.

Future Scope

Possible future improvements include:

Design of larger SRAM arrays
SRAM sense amplifier implementation
Precharge circuit design
SRAM power and delay optimization
Static Noise Margin (SNM) analysis
SRAM PVT analysis
FPGA implementation
Larger memory capacity
Pipelined processing
Memory controller optimization
Integration of the analog SRAM cell with a larger memory array
Project Status

Analog Design: Completed
6T SRAM Layout: Completed
Digital SRAM: Completed
FSM Controller: Completed
ALU: Completed
SRAM Integration: Completed
RTL Simulation: Completed
Verification: Completed
