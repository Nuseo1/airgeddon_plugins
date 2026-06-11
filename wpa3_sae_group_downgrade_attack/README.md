# WPA3‑SAE Group Downgrade Attack Plugin for airgeddon
This airgeddon plugin performs a **WPA3‑SAE Group Downgrade Attack** – a cryptographic downgrade technique discovered during the [Dragonblood](https://wpa3.mathyvanhoef.com/) research (CVE‑2019‑9499).
Instead of the mandatory **group 19** (NIST P‑256 elliptic curve), the attack floods the target access point with SAE Commit frames that propose the weak multiplicative groups **MODP 2048 (group 22)** and **MODP 3072 (group 23)**. If the AP accepts one of these groups, the subsequent handshake uses much weaker cryptography, making offline brute‑force or dictionary attacks on the Wi‑Fi password practical.

---

## Features

- **Two weak MODP groups** – alternates between MODP 2048 and MODP 3072 to maximise negotiation pressure
- **Random source MACs** – each commit frame uses a different MAC address to bypass simple anti‑clogging filters
- **Multi‑language** – fully translated into all 13 airgeddon languages
- **Rate‑limited** – prevents adapter lock‑up while maintaining maximum effectiveness
- **No SAE parameter extraction required** – the attack uses cryptographically random scalars and elements; the AP processes the group negotiation before validating the cryptographic material

---

## How It Works

1. The Bash plugin validates the target (WPA3‑SAE network, monitor mode enabled) and sets the wireless interface to the correct channel.
2. The Python engine then floods the access point with **64‑frame bursts**:
   - **50 % group 22** (MODP 2048) – 32‑byte scalar, 256‑byte element
   - **50 % group 23** (MODP 3072) – 32‑byte scalar, 384‑byte element
3. Each frame carries a **random source MAC** and a **random scalar/element pair**, so the AP sees what appears to be many different clients all proposing weak groups.
4. If the AP is configured to accept non‑mandatory groups, it will begin processing the handshake with the weaker MODP group – at which point an attacker can capture the handshake and perform an offline password attack.
5. The attack runs indefinitely until you press **Enter** in the airgeddon control window.

---

## Prerequisites

- **airgeddon ≥ 12.0**
- **python3** (≥ 3.6)
- **python3-scapy** – install with: `sudo apt install python3-scapy`
- A Wi‑Fi adapter in **monitor mode** on the target channel
- The target network must be **WPA3‑SAE (Personal)** and must be configured to accept MODP groups (many APs only support the mandatory group 19)

---

## Recommended Hardware

For reliable packet injection, use a dedicated Wi‑Fi adapter with a supported chipset.

**✅ Works and recommended**
- Alfa AWUS036ACH (Realtek RTL8812AU)
- Any other adapter with the RTL8812AU chipset
- Atheros AR9271 chipset has also been confirmed to work

In practice, many other adapters also perform reliably. The author has successfully used the built‑in Intel Wi‑Fi adapter:
- **Intel Corporation Wi‑Fi 5 (802.11ac) Wireless-AC 9x6x [Thunder Peak] (rev 29)** (integrated in many laptops)
With this adapter, the attack produced stable packet injection and no adapter lock‑ups. If you have a different chipset, it is worth trying it out – many modern adapters can inject frames correctly.

---

## Installation

1. Copy `downgrade_attack.sh` and `downgrade_attack.py` to the airgeddon plugins folder:
   ```bash
   cp downgrade_attack.sh downgrade_attack.py ~/.airgeddon/plugins/
   ```
2. Launch airgeddon as usual – the attack will appear in the **WPA3 attacks menu** as *“WPA3 Group Downgrade attack”*.

> ℹ️ **Note on plugin slots:** airgeddon menu **11** (WPA3 attacks) only displays a limited number of plugins. If you already have several other plugin files in `~/.airgeddon/plugins/`, the new attack may not show up unless you temporarily move some of the other plugins out of the folder. Keep only the plugins you actively need to see the entry.

---

## Technical Background

### The Security Group Downgrade Flaw (Dragonblood)

The WPA3 Dragonfly handshake allows the client to propose which cryptographic group it wishes to use. If the AP does not support the proposed group, it sends a decline message, and the client tries another group. This negotiation continues until both sides agree.

An attacker can exploit this by impersonating a client and **only** proposing weak MODP groups (22, 23). If the AP accepts one of them, the entire handshake runs with significantly weaker cryptography:

| Group | Type | Security Level |
|-------|------|---------------|
| 19 | NIST P‑256 (ECC) | ≈ 128‑bit (mandatory) |
| 22 | MODP 2048 | ≈ 112‑bit |
| 23 | MODP 3072 | ≈ 128‑bit but slower |
| 24 | MODP 4096 | ≈ 152‑bit |

The weakness is not only the nominal security level – MODP groups are also vulnerable to timing‑based side‑channel attacks (as described in the Dragonblood paper), which can leak information about the password during the handshake computation. This makes brute‑force attacks significantly faster than they would be against the ECC group 19.

> ⚠️ **For authorised research and isolated test environments only.** Using this against networks you do not own violates computer crime laws.

---

## Credits

- [**Mathy Vanhoef**](https://twitter.com/vanhoefm) & **Eyal Ronen** – Dragonblood research ([paper](https://eprint.iacr.org/2019/383))
- Based on research code from [WPA3‑SAE‑DoS‑Research‑Suite](https://github.com/Nuseo1/WPA3-SAE-DoS-Research-Suite)
