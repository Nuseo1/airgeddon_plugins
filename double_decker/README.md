# WPA3‑SAE Double Decker Attack Plugin for airgeddon

This airgeddon plugin performs a **WPA3‑SAE Double Decker denial‑of‑service attack** – the most powerful technique described in the paper *“[How is your Wi-Fi connection today? DoS attacks on WPA3-SAE](https://doi.org/10.1016/j.jisa.2021.103058)”*.
It combines the **Omnivore** and **Muted** attack modes to overload the target router’s memory and CPU **before and after its anti‑DoS defense activates**, maximizing stress.

> **“Double Decker”** – Combines omnivore & muted for maximum stress.  
> Effect: Described by the authors as “powerful”. It attacks the router simultaneously before and after its anti‑DoS defense is activated. Maximum memory and CPU load.  
> Most effective band: Both bands (Universal).  
> Suitable for: **WPA3** (SAE/Personal).

## Features

- **20 unique SAE scalar / finite field pairs** – automatically captured or manually entered  
- **6‑GHz ready** – correctly calculates center frequencies for 6GHz band channels  
- **Multi‑language** – fully translated into all 13 airgeddon languages  
- **Rate‑limited** – prevents adapter lock‑up while maintaining maximum effectiveness  

## How It Works

1. The plugin first obtains **20 valid SAE commit parameter pairs** (scalar and finite field element) from the target network.  
   - *Automatic capture* uses `wpa_supplicant` to force failed authentications and `airodump‑ng` + Scapy to extract the values.  
   - *Manual entry* is also supported.  
2. The Python engine then floods the access point with **128‑frame bursts** at 1000 frames/s:  
   - **50 % Omnivore** – random source MACs, making the attack look like many different stations and filling the router’s memory before its defense kicks in.  
   - **50 % Muted** – all frames use the same static MAC, mimicking a single persistent station that bypasses the anti‑DoS filter once it activates.  
3. The attack runs indefinitely until you stop it (press `Enter` in the airgeddon control window).

## Prerequisites

- **airgeddon** ≥ 12.01  
- **wpa_supplicant**  
- A second Wi‑Fi adapter (managed mode) for automatic SAE capture – optional if you already have 20 pairs.

## Recommended Hardware

For reliable packet injection required by this attack, use a dedicated Wi‑Fi adapter with a supported chipset.

**✅ Works and recommended**  
- **Alfa AWUS036ACH** (Realtek RTL8812AU) – used in the original research paper.  
- Any other adapter with the **RTL8812AU** chipset.  
- Atheros **AR9271** chipset has also been confirmed to work.

**❌ Does NOT work**  
- Ralink RT3070
- MediaTek MT7610U 
- MediaTek MT7612U  
- MediaTek MT7921U  

## Installation

1. Copy `double_decker_attack.sh` and `double_decker_attack.py` to the airgeddon plugins folder:  
   `plugins/`  
2. Launch airgeddon as usual – the attack will appear in the WPA3 attacks menu.

## Credits

- *WPA3‑SAE DoS research* 
- Based on `sae_extractor.py` and research code from [WPA3-SAE-DoS-Research-Suite](https://github.com/Nuseo1/WPA3-SAE-DoS-Research-Suite)
