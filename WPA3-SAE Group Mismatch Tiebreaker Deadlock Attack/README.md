# WPA3-SAE Group Mismatch Tiebreaker Deadlock Plugin for airgeddon

This airgeddon plugin performs a **WPA3-SAE Group Mismatch Tiebreaker Deadlock Attack** (also known as the MAC Tiebreaker Deadlock). It exploits a logical state machine flaw in the WPA3-SAE protocol to cause a severe Denial of Service (DoS).

Instead of relying on cryptographic weaknesses, this attack targets the SAE group negotiation "tiebreaker" mechanism. By spoofing a MAC address that is numerically larger than the target Access Point (AP) and sending malformed SAE Commit frames, it forces the AP into a "yielder" role. Due to missing error handling in the IEEE 802.11-2020 standard (addressed in Erratum M), the AP fails to deallocate the protocol instance, permanently blocking it and eventually exhausting its resources.

---

## Features

- **Protocol State Machine Exploitation** – Exploits a logical flaw in the IEEE 802.11 standard rather than brute-forcing cryptography.
- **No Crypto Calculations Required** – The attack does not need to compute valid scalars or finite field values, making it extremely lightweight and fast.
- **Smart MAC Spoofing** – Automatically generates random unicast MAC addresses that are strictly numerically greater than the target AP's BSSID to reliably trigger the tiebreaker.
- **Alternating Group Mismatch** – Alternates between different groups (e.g., Group 19 and 20) to maximize deadlock probability during negotiation.
- **Adapter-Independent Design** – Carefully designed to be as hardware-agnostic as possible, working on a wide variety of Wi-Fi chipsets.
- **Multi-language** – Fully translated into all 13 airgeddon languages.
- **High-Impact DoS** – Can permanently exhaust the AP's protocol instance memory, preventing legitimate clients from connecting.

---

## How It Works

1. The Bash plugin validates the target (WPA3-SAE network, monitor mode enabled) and sets the wireless interface to the correct channel.
2. The Python engine continuously generates a spoofed MAC address that is numerically **greater** than the target AP's MAC address.
3. It floods the AP with **128-frame bursts** of SAE Commit messages, proposing alternating groups to force a group mismatch.
4. Each frame is deliberately crafted with an invalid, zeroed-out payload. **No valid scalar or finite field values are necessary** for this attack to succeed, completely bypassing the need for complex cryptographic calculations.
5. According to the WPA3 SAE tiebreaker rules, the AP (having the lesser MAC address) must yield to the attacker's greater MAC, discarding its own commit to process the attacker's.
6. When the AP attempts to process the malformed material during this yielding phase, the state machine encounters an unhandled error. The protocol instance becomes permanently deadlocked in the `Committed` state.
7. Over time, this exhausts the AP's available memory or concurrent instance limits, causing a complete Denial of Service.
8. The attack runs indefinitely until you press **Enter** in the airgeddon control window.

---

## Prerequisites

- **airgeddon ≥ 12.01**
- **python3** (≥ 3.6)
- **python3-scapy** – install with: `sudo apt install python3-scapy`
- A Wi-Fi adapter in **monitor mode** on the target channel
- The target network must be **WPA3-SAE (Personal)**

---

## Recommended Hardware

The author has made a significant effort to develop an attack that is **adapter-independent**, meaning it should work out-of-the-box with almost any Wi-Fi card capable of monitor mode and packet injection. 

**✅ Works and recommended**
- Alfa AWUS036ACH (Realtek RTL8812AU)
- Any other adapter with the RTL8812AU chipset
- Atheros AR9271 chipset has also been confirmed to work

**Specific Adapter Notes:**
- **Intel Corporation Wi-Fi 5 (802.11ac) Wireless-AC 9x6x [Thunder Peak] (rev 29):** The author has successfully used this built-in laptop adapter, achieving stable packet injection without adapter lock-ups.
- **Ralink RT3070:** The author has noted that this chipset works successfully, but **only if the device is not currently connected to the internet** while executing the attack.

If you have a different chipset, it is highly recommended to try it out – the hardware-agnostic nature of this script allows many modern adapters to inject the frames correctly.

---

## Installation

1. Copy `deadlock_attack.sh` and `deadlock_attack.py` to the airgeddon plugins folder:
   ```bash
   cp deadlock_attack.sh deadlock_attack.py plugins/
   
2. Launch airgeddon as usual – the attack will appear in the WPA3 attacks menu as "WPA3 Tiebreaker Deadlock attack".
    
## Technical Background
The SAE Tiebreaker Deadlock Flaw

The WPA3 Simultaneous Authentication of Equals (SAE) protocol allows both peers to initiate the handshake simultaneously. If both peers propose different but supported cryptographic groups, a "tiebreaker" mechanism is invoked to resolve the mismatch without entering an infinite loop. The IEEE 802.11 standard dictates that the peer with the numerically lesser MAC address must assume the "yielder" role, discarding its own group choice and processing the commit frame of the peer with the greater MAC address.

This plugin exploits a critical omission in the SAE finite state machine specification (identified during formal security analyses and classified under Erratum M: Group Mismatch Error Handling in the IEEE 802.11-2020 standard corrections).

If a peer (the AP) is forced into the yielder role and attempts to process the incoming Commit frame, but the frame contains invalid cryptographic material (which requires zero computational effort from the attacker, as no valid scalars or finite values are calculated), the processing naturally fails. However, the original standard missed specifying the proper error handling (such as generating a Fail or Del event) for this specific scenario.

Without an event to trigger a state transition or deallocate the protocol instance, the state machine becomes permanently deadlocked in the Committed state. Because the instance is never cleared from memory, an attacker can continuously send these malformed frames using different spoofed MAC addresses, rapidly exhausting the AP's resources and resulting in a Denial of Service (DoS) for all legitimate network traffic.

## Credits

- IEEE 802.11 Working Group – Acknowledged and patched as Erratum M in the standard update.

- Code from [WPA3-SAE Formal Attack Suite](https://github.com/Nuseo1/WPA3-SAE-Formal-Attack-Suite).
