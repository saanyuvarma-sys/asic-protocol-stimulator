UART Receiver RTL Design and Verification

A Verilog-based UART (Universal Asynchronous Receiver-Transmitter) receiver designed and simulated to explore serial communication, finite-state machines, and RTL verification.

Project Overview

UART is a widely used serial communication protocol in embedded systems and digital hardware. This project implements a UART receiver that captures serial data, reconstructs an 8-bit byte, and checks the stop bit to detect framing errors.

The design was developed and verified through simulation.

Objectives

- Implement a UART receiver using Verilog HDL.
- Understand FSM-based RTL design.
- Receive 8-bit serial data in LSB-first order.
- Develop a testbench to verify receiver behavior.
- Detect invalid stop bits using framing-error logic.
- Inspect simulation results and waveforms.

Design Features

- FSM-based receiver with IDLE, START_BIT, DATA_BITS, and STOP_BIT states.
- 8-bit serial data reception.
- Configurable clock cycles per bit through "CLKS_PER_BIT".
- "rx_done" signal to indicate successful byte reception.
- "framing_error" signal to indicate an invalid stop bit.
- Testbench-driven functional verification.

Tools Used

- Verilog HDL — RTL implementation
- Icarus Verilog — compilation and simulation
- EDA Playground — online development environment
- EPWave — waveform inspection

Verification and Results

The simulation was used to test valid UART frames and an invalid stop-bit condition.

Test scenario| Expected behavior| Result
Valid frame: "A5"| Byte received successfully| PASS
Valid frame: "3C"| Byte received successfully| PASS
Invalid stop bit| Framing error detected| PASS

The testbench reported successful results for all three scenarios.

Earlier functional testing also covered the data patterns "A5", "3C", "55", "FF", and "00".

Repository Structure

- "design.sv" — UART receiver RTL design
- "testbench.sv" — simulation testbench
- "README.md" — project documentation
- Waveform screenshot — simulation evidence, if uploaded

Key Learning Outcomes

- Translating digital design concepts into synthesizable RTL.
- Implementing and understanding finite-state machines.
- Writing testbenches for functional verification.
- Debugging serial data reception and stop-bit handling.
- Interpreting simulation logs and waveforms.

Scope and Limitations

This project demonstrates RTL design and functional simulation. It does not claim physical chip fabrication, FPGA hardware validation, or a complete industrial UART implementation.

Future Improvements

- Add parity-bit generation/checking support.
- Test additional baud-rate configurations.
- Improve reset and error-recovery verification.
- Explore synthesis and area/timing analysis using suitable EDA tools.

Author

Saanyu Varma
Second-year Electronics and Communication Engineering student
Interested in RTL Design, Digital Design, and VLSI.

GitHub: https://github.com/saanyuvarma-sys

---

This project is an educational RTL design and verification exercise.