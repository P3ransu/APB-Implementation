# APB-Implementation
# APB Slave UVM Verification Environment

This repository contains a complete Design Verification (DV) environment built from scratch using the Universal Verification Methodology (UVM) and SystemVerilog. It is designed to verify a custom 32-bit Advanced Peripheral Bus (APB) Slave memory peripheral.

## Project Overview

The objective of this project is to model and verify the AMBA APB protocol's strictly timed, two-cycle state machine (IDLE $\rightarrow$ SETUP $\rightarrow$ ACCESS). The UVM testbench stimulates the Design Under Test (DUT) with randomized read/write transactions, models the expected memory state using a scoreboard, and handles protocol-specific edge cases such as reset timing and wait-state stalling.

## Features Verified

* **Protocol Compliance:** Enforces the strict 2-clock cycle rule (Setup Phase followed by Access Phase).
* **Reset Handling:** Ensures the driver respects the active-low `presetn` signal before pushing transactions.
* **Wait State Management:** Fully supports dynamic stalling via the slave's `pready` signal without dropping data.
* **Data Integrity:** Employs an associative array in the UVM Scoreboard as a golden reference model to compare expected vs. actual read data on the `prdata` bus.

## UVM Architecture

The testbench follows standard UVM hierarchical structuring:

* **`tb_top.sv`**: Instantiates the physical clock/reset, the interface, and the DUT. Passes the virtual interface to the UVM configuration database.
* **`apb_test.sv`**: The top-level test class that boots the environment and starts the sequences.
* **`apb_env.sv`**: The container wrapping the Agent and the Scoreboard.
* **`apb_agent.sv`**: Connects the Sequencer, Driver, and Monitor.
* **`apb_scoreboard.sv`**: Subscribes to the Monitor's analysis port and verifies read transactions against the reference memory model.
* **`apb_driver.sv`**: Actively drives `psel`, `penable`, `pwrite`, `paddr`, and `pwdata` onto the virtual interface.
* **`apb_monitor.sv`**: Passively samples the bus on valid `pready` cycles and broadcasts the observed transaction.
* **`apb_sequence.sv`**: Generates constrained-random stimulus (e.g., forcing a Write to a random address followed immediately by a Read to the exact same address).

## The Heirarchical Structure 

```text
├── src/
│   ├── apb_slave_dut.sv
│   └── apb_if.sv
├── verif/
│   ├── apb_item.sv
│   ├── apb_sequence.sv
│   ├── apb_sequencer.sv
│   ├── apb_driver.sv
│   ├── apb_monitor.sv
│   ├── apb_agent.sv
│   ├── apb_scoreboard.sv
│   ├── apb_env.sv
│   └── apb_test.sv
└── tb_top.sv
