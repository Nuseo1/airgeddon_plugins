# airgeddon plugins

This repository contains custom plugins for [airgeddon](https://github.com/v1s1t0r1sh3r3/airgeddon), the multi-use bash script for auditing wireless networks.

## Available Plugins

### 1. Manual Evil Twin Control (`custom_et_control`)
This plugin gives you full manual control over your Evil Twin attacks. By default, airgeddon enforces certain parameters when setting up an Evil Twin. This plugin intercepts the configuration phase and prompts you to manually define:
- **BSSID:** Choose the exact original MAC, a completely fake one, or a custom one you type in.
- **Channel:** Change the broadcasting channel of your Evil Twin independent of the target.
- **ESSID:** Choose the exact original name, a custom name, or the standard fake airgeddon name.

It supports 13 languages natively and is fully compatible with other Captive Portal plugins.

### 2. WPA3-SAE Double Decker DoS (`double_decker_attack`)
This plugin introduces the advanced **Double Decker DoS attack** against WPA3 networks. It combines the *Omnivore* (random MACs) and *Muted* (static MAC) attack techniques while sending 20 pre-captured SAE authentication pairs in rapid bursts.
This heavily stresses the target AP's CPU and memory, effectively denying service to legitimate WPA3 clients. It is fully compatible with 2.4 GHz, 5 GHz, and 6 GHz bands.

### 3. WPA3‑SAE Group Downgrade Attack (`downgrade_attack`)
This plugin performs a cryptographic downgrade attack against WPA3‑SAE networks, based on the Dragonblood research (CVE‑2019‑9499). Instead of the mandatory group 19 (NIST P‑256 ECC), the attack floods the target AP with SAE Commit frames that propose the weak MODP groups 2048 (22) and 3072 (23). If the AP accepts one of these groups, the subsequent handshake uses significantly weaker cryptography, enabling offline brute‑force password recovery.

- **No SAE parameter extraction required** – uses cryptographically random scalars and elements
- **Fully multi‑language** – 13 languages built‑in
- **Tested with various adapters** including Intel Wi‑Fi 5 (802.11ac) Wireless‑AC 9x6x [Thunder Peak] and Alfa AWUS036ACH (RTL8812AU)

### 4. WPA3-SAE Group Mismatch Tiebreaker Deadlock (`deadlock_attack`)

This plugin exploits a logical state machine flaw in the WPA3-SAE protocol to cause a severe Denial of Service (DoS). It targets the SAE group negotiation "tiebreaker" mechanism by spoofing a MAC address that is numerically larger than the target AP and flooding it with malformed SAE Commit frames proposing alternating groups. Due to missing error handling in the IEEE 802.11-2020 standard (addressed in Erratum M), the AP fails to deallocate the "yielding" protocol instance, permanently blocking it and exhausting its resources.

* **Protocol State Machine Exploitation** – Exploits a logical standard flaw rather than brute-forcing cryptography.
* **No Crypto Calculations Required** – Uses empty payloads, bypassing the need for valid scalars or finite field values.
* **Adapter-Independent Design** – Carefully designed to work out-of-the-box on a wide variety of Wi-Fi chipsets (e.g., Intel Wireless-AC, Alfa AWUS036ACH, Ralink RT3070).
* **Fully multi-language** – 13 languages built-in.

### 5. WPA3-SAE Companion Suite + Auto-Close Workflow (WPA2/WPA3 Transition Mode)

This external companion workflow is designed specifically for **WPA2/WPA3 Transition Mode** networks, where a valid WPA2 handshake is captured first!

`airgeddon` still verifies the entered password directly against that captured handshake as usual. The WPA3-SAE DoS script just runs alongside `airgeddon` to block WPA3/PMF (802.11w) clients that are immune to standard WPA2 deauths, forcing them to connect to the Evil Twin. Also, the monitor script (`watch_pass_auto_close_en.sh`) doesn't stop on wrong attempts (`ag.et_attempts.txt`) — it only stops the WPA3 attack once `airgeddon` has verified the password against the handshake and written the final `evil_twin_captive_portal_password-*.txt` file.

* **WPA2/WPA3 Transition Mode Support** – Combines `airgeddon`'s native WPA2 handshake verification with parallel WPA3-SAE DoS against PMF-protected clients.
* **Automatic Channel Tracking** – Detects if the target AP changes channels and automatically hops the attack adapter(s) to the new channel.
* **Verified Auto-Close (`SIGTERM`)** – Logs live inputs and failed attempts without interrupting the attack, terminating the WPA3 DoS only after `airgeddon` confirms the correct password.
* **Full Documentation & Scripts:** [WPA3-SAE-Formal-Attack-Suite – Step 4: airgeddon Captive Portal + Auto-Close Workflow](https://github.com/Nuseo1/WPA3-SAE-Formal-Attack-Suite/tree/dev#step-4-optional-airgeddon-captive-portal--auto-close-workflow)

---

## Installation
1. Clone this repository or download the `.sh` and `.py` (if applicable) files of the plugin you want.
2. Place the plugin files directly into the `/plugins/` folder inside your airgeddon directory.
3. Launch airgeddon. The plugins will be loaded automatically if enabled.

*For more detailed instructions, please check the `README.md` file inside each plugin's respective subfolder.*
