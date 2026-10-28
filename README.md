ASIC Protocol Stimulator Using Verilog HDL

Overview

This project explores RTL design and simulation-based verification of digital communication protocols for ASIC testing.

The initial implementation focuses on a UART receiver written in Verilog HDL and a testbench for applying serial input patterns and checking received data.

Objectives

- Develop a parameterized UART receiver.
- Verify serial communication using a Verilog testbench.
- Inspect simulation waveforms and debug signal timing.
- Extend the architecture with SPI and I2C protocol modules in future stages.

Current Implementation

- HDL: Verilog/SystemVerilog-compatible RTL
- Simulation: Icarus Verilog through EDA Playground
- Design file: "design.sv"
- Testbench: "testbench.sv"
- Initial UART test patterns: "A5", "3C", "55", "FF", "00"

Verification

The testbench generates UART frames and checks the receiver output. Actual pass/fail results should be recorded from the simulator console after successful execution.

Project Status

UART RTL and waveform exploration are in progress. SPI and I2C support, additional verification, and further design analysis are planned.

Future Improvements

- Add SPI master/slave protocol support.
- Add I2C transaction support.
- Expand corner-case and error-condition tests.
- Explore synthesis and timing analysis when suitable tools are available.

Scope

This is an RTL design and simulation project. It does not claim fabrication of a physical ASIC or measured silicon performance.

Tools

- EDA Playground
- Icarus Verilog
- GitHub
