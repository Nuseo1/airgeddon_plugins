#!/usr/bin/env bash
#Global shellcheck disabled warnings
#shellcheck disable=SC2034,SC2154

plugin_name="WPA3-SAE Group Downgrade Attack"
plugin_description="Force weak MODP groups on a WPA3-SAE AP"
plugin_author="Nuseo1"

plugin_enabled=1

plugin_minimum_ag_affected_version="12.01"
plugin_maximum_ag_affected_version=""
plugin_distros_supported=("*")

function downgrade_attack_prehook_hookable_wpa3_attacks_menu() {

	if [ "${arr['ENGLISH',756]}" = "6.  WPA3 group downgrade attack" ]; then
		plugin_x="downgrade_attack_option"
		plugin_x_under_construction=""
	elif [ "${arr['ENGLISH',757]}" = "7.  WPA3 group downgrade attack" ]; then
		plugin_y="downgrade_attack_option"
		plugin_y_under_construction=""
	elif [ "${arr['ENGLISH',812]}" = "8.  WPA3 group downgrade attack" ]; then
		plugin_z="downgrade_attack_option"
		plugin_z_under_construction=""
	fi
}

function downgrade_attack_prehook_hookable_for_languages() {

	if [ "${arr['ENGLISH',756]}" = "6.  WPA3 attack (use a plugin here)" ]; then
		arr["ENGLISH",756]="6.  WPA3 group downgrade attack"
		arr["SPANISH",756]="6.  Ataque de downgrade de WPA3 group"
		arr["FRENCH",756]="\${pending_of_translation} 6.  Attaque de downgrade de groupe WPA3"
		arr["CATALAN",756]="\${pending_of_translation} 6.  Atac de downgrade de grup WPA3"
		arr["PORTUGUESE",756]="\${pending_of_translation} 6.  Ataque de downgrade de grupo WPA3"
		arr["RUSSIAN",756]="\${pending_of_translation} 6.  Атака downgrade группы WPA3"
		arr["GREEK",756]="\${pending_of_translation} 6.  Επίθεση downgrade ομάδας WPA3"
		arr["ITALIAN",756]="\${pending_of_translation} 6.  Attacco di downgrade di gruppo WPA3"
		arr["POLISH",756]="\${pending_of_translation} 6.  Atak downgrade grupy WPA3"
		arr["GERMAN",756]="6.  WPA3 Gruppen Downgrade Angriff"
		arr["TURKISH",756]="\${pending_of_translation} 6.  WPA3 grup downgrade saldırısı"
		arr["ARABIC",756]="\${pending_of_translation} 6.  هجوم downgrade مجموعة WPA3"
		arr["CHINESE",756]="\${pending_of_translation} 6.  WPA3 组 downgrade 攻击"
	elif [ "${arr['ENGLISH',757]}" = "7.  WPA3 attack (use a plugin here)" ]; then
		arr["ENGLISH",757]="7.  WPA3 group downgrade attack"
		arr["SPANISH",757]="7.  Ataque de downgrade de WPA3 group"
		arr["FRENCH",757]="\${pending_of_translation} 7.  Attaque de downgrade de groupe WPA3"
		arr["CATALAN",757]="\${pending_of_translation} 7.  Atac de downgrade de grup WPA3"
		arr["PORTUGUESE",757]="\${pending_of_translation} 7.  Ataque de downgrade de grupo WPA3"
		arr["RUSSIAN",757]="\${pending_of_translation} 7.  Атака downgrade группы WPA3"
		arr["GREEK",757]="\${pending_of_translation} 7.  Επίθεση downgrade ομάδας WPA3"
		arr["ITALIAN",757]="\${pending_of_translation} 7.  Attacco di downgrade di gruppo WPA3"
		arr["POLISH",757]="\${pending_of_translation} 7.  Atak downgrade grupy WPA3"
		arr["GERMAN",757]="7.  WPA3 Gruppen Downgrade Angriff"
		arr["TURKISH",757]="\${pending_of_translation} 7.  WPA3 grup downgrade saldırısı"
		arr["ARABIC",757]="\${pending_of_translation} 7.  هجوم downgrade مجموعة WPA3"
		arr["CHINESE",757]="\${pending_of_translation} 7.  WPA3 组 downgrade 攻击"
	elif [ "${arr['ENGLISH',812]}" = "8.  WPA3 attack (use a plugin here)" ]; then
		arr["ENGLISH",812]="8.  WPA3 group downgrade attack"
		arr["SPANISH",812]="8.  Ataque de downgrade de WPA3 group"
		arr["FRENCH",812]="\${pending_of_translation} 8.  Attaque de downgrade de groupe WPA3"
		arr["CATALAN",812]="\${pending_of_translation} 8.  Atac de downgrade de grup WPA3"
		arr["PORTUGUESE",812]="\${pending_of_translation} 8.  Ataque de downgrade de grupo WPA3"
		arr["RUSSIAN",812]="\${pending_of_translation} 8.  Атака downgrade группы WPA3"
		arr["GREEK",812]="\${pending_of_translation} 8.  Επίθεση downgrade ομάδας WPA3"
		arr["ITALIAN",812]="\${pending_of_translation} 8.  Attacco di downgrade di gruppo WPA3"
		arr["POLISH",812]="\${pending_of_translation} 8.  Atak downgrade grupy WPA3"
		arr["GERMAN",812]=" 8.  WPA3 Gruppen Downgrade Angriff"
		arr["TURKISH",812]="\${pending_of_translation} 8.  WPA3 grup downgrade saldırısı"
		arr["ARABIC",812]="\${pending_of_translation} 8.  هجوم downgrade مجموعة WPA3"
		arr["CHINESE",812]="\${pending_of_translation} 8.  WPA3 组 downgrade 攻击"
	fi

	arr["ENGLISH","downgrade_attack_1"]="WPA3 group downgrade forces the AP to accept weak MODP groups (22/23)"
	arr["SPANISH","downgrade_attack_1"]="El downgrade de WPA3 group fuerza al AP a aceptar grupos MODP débiles (22/23)"
	arr["FRENCH","downgrade_attack_1"]="\${pending_of_translation} Le downgrade de groupe WPA3 force le point d'accès à accepter les groupes MODP faibles (22/23)"
	arr["CATALAN","downgrade_attack_1"]="\${pending_of_translation} El downgrade de grup WPA3 força el punt d'accés a acceptar grups MODP febles (22/23)"
	arr["PORTUGUESE","downgrade_attack_1"]="\${pending_of_translation} O downgrade de grupo WPA3 força o AP a aceitar grupos MODP fracos (22/23)"
	arr["RUSSIAN","downgrade_attack_1"]="\${pending_of_translation} Downgrade группы WPA3 заставляет точку доступа принимать слабые группы MODP (22/23)"
	arr["GREEK","downgrade_attack_1"]="\${pending_of_translation} Το WPA3 group downgrade αναγκάζει το AP να αποδεχτεί αδύναμες ομάδες MODP (22/23)"
	arr["ITALIAN","downgrade_attack_1"]="\${pending_of_translation} Il downgrade di gruppo WPA3 forza l'AP ad accettare gruppi MODP deboli (22/23)"
	arr["POLISH","downgrade_attack_1"]="\${pending_of_translation} Downgrade grupy WPA3 zmusza AP do akceptacji słabych grup MODP (22/23)"
	arr["GERMAN","downgrade_attack_1"]="WPA3 Gruppen Downgrade zwingt den AP zur Annahme schwacher MODP-Gruppen (22/23)"
	arr["TURKISH","downgrade_attack_1"]="\${pending_of_translation} WPA3 grup downgrade, AP'yi zayıf MODP gruplarını (22/23) kabul etmeye zorlar"
	arr["ARABIC","downgrade_attack_1"]="\${pending_of_translation} يجبر downgrade مجموعة WPA3 نقطة الوصول على قبول مجموعات MODP الضعيفة (22/23)"
	arr["CHINESE","downgrade_attack_1"]="\${pending_of_translation} WPA3 组 downgrade 强制接入点接受弱 MODP 组（22/23）"
	wpa3_hints+=("downgrade_attack_1")

	arr["ENGLISH","downgrade_attack_2"]="This attack requires to have python3.6+ installed on your system"
	arr["SPANISH","downgrade_attack_2"]="Este ataque requiere tener python3.6+ instalado en el sistema"
	arr["FRENCH","downgrade_attack_2"]="\${pending_of_translation} Cette attaque nécessite d'avoir python3.6+ installé sur le système"
	arr["CATALAN","downgrade_attack_2"]="\${pending_of_translation} Aquest atac requereix tenir python3.6+ instal·lat al sistema"
	arr["PORTUGUESE","downgrade_attack_2"]="\${pending_of_translation} Este ataque requer python3.6+ instalado no sistema"
	arr["RUSSIAN","downgrade_attack_2"]="\${pending_of_translation} Для этой атаки необходимо, чтобы в системе был установлен python3.6+"
	arr["GREEK","downgrade_attack_2"]="\${pending_of_translation} Αυτή η επίθεση απαιτεί την εγκατάσταση python3.6+ στο σύστημα"
	arr["ITALIAN","downgrade_attack_2"]="\${pending_of_translation} Questo attacco richiede che python3.6+ sia installato nel sistema"
	arr["POLISH","downgrade_attack_2"]="\${pending_of_translation} Ten atak wymaga zainstalowania python3.6+ w systemie"
	arr["GERMAN","downgrade_attack_2"]="Für diesen Angriff muss python3.6+ auf dem System installiert sein"
	arr["TURKISH","downgrade_attack_2"]="\${pending_of_translation} Bu saldırı için sisteminizde python3.6+ kurulu olmalıdır"
	arr["ARABIC","downgrade_attack_2"]="\${pending_of_translation} يتطلب هذا الهجوم تثبيت python3.6+ على النظام"
	arr["CHINESE","downgrade_attack_2"]="\${pending_of_translation} 此攻击需要在系统上安装 python3.6+"

	arr["ENGLISH","downgrade_attack_3"]="The python3 script required as part of this plugin to run this attack is missing. Please make sure that the file \"\${normal_color}downgrade_attack.py\${red_color}\" exists and that it is in the plugins dir next to the \"\${normal_color}downgrade_attack.sh\${red_color}\" file"
	arr["SPANISH","downgrade_attack_3"]="El script de python3 requerido como parte de este plugin para ejecutar este ataque no se encuentra. Por favor, asegúrate de que existe el fichero \"\${normal_color}downgrade_attack.py\${red_color}\" y que está en la carpeta de plugins junto al fichero \"\${normal_color}downgrade_attack.sh\${red_color}\""
	arr["FRENCH","downgrade_attack_3"]="\${pending_of_translation} Le script python3 requis pour exécuter cette attaque est manquant. Assurez-vous que le fichier \"\${normal_color}downgrade_attack.py\${red_color}\" existe et se trouve dans le dossier plugins à côté du fichier \"\${normal_color}downgrade_attack.sh\${red_color}\""
	arr["CATALAN","downgrade_attack_3"]="\${pending_of_translation} El script de python3 requerit per executar aquest atac no es troba. Assegureu-vos que existeix el fitxer \"\${normal_color}downgrade_attack.py\${red_color}\" i que està a la carpeta de plugins al costat del fitxer \"\${normal_color}downgrade_attack.sh\${red_color}\""
	arr["PORTUGUESE","downgrade_attack_3"]="\${pending_of_translation} O script python3 necessário para executar este ataque está ausente. Verifique se o arquivo \"\${normal_color}downgrade_attack.py\${red_color}\" existe e está na pasta de plugins junto ao arquivo \"\${normal_color}downgrade_attack.sh\${red_color}\""
	arr["RUSSIAN","downgrade_attack_3"]="\${pending_of_translation} Скрипт python3, необходимый для запуска этой атаки, отсутствует. Убедитесь, что файл \"\${normal_color}downgrade_attack.py\${red_color}\" существует и находится в папке plugins рядом с файлом \"\${normal_color}downgrade_attack.sh\${red_color}\""
	arr["GREEK","downgrade_attack_3"]="\${pending_of_translation} Το script python3 που απαιτείται για αυτή την επίθεση λείπει. Βεβαιωθείτε ότι το αρχείο \"\${normal_color}downgrade_attack.py\${red_color}\" υπάρχει και βρίσκεται στον φάκελο plugins δίπλα στο αρχείο \"\${normal_color}downgrade_attack.sh\${red_color}\""
	arr["ITALIAN","downgrade_attack_3"]="\${pending_of_translation} Lo script python3 richiesto per eseguire questo attacco è assente. Assicurati che il file \"\${normal_color}downgrade_attack.py\${red_color}\" esista e sia nella cartella dei plugin accanto al file \"\${normal_color}downgrade_attack.sh\${red_color}\""
	arr["POLISH","downgrade_attack_3"]="\${pending_of_translation} Skrypt python3 wymagany do przeprowadzenia tego ataku nie istnieje. Upewnij się, że plik \"\${normal_color}downgrade_attack.py\${red_color}\" istnieje i znajduje się w folderze plugins obok pliku \"\${normal_color}downgrade_attack.sh\${red_color}\""
	arr["GERMAN","downgrade_attack_3"]="Das python3-Skript, das für diesen Angriff erforderlich ist, fehlt. Bitte stelle sicher, dass die Datei \"\${normal_color}downgrade_attack.py\${red_color}\" vorhanden ist und sich im Plugin-Ordner neben der Datei \"\${normal_color}downgrade_attack.sh\${red_color}\" befindet"
	arr["TURKISH","downgrade_attack_3"]="\${pending_of_translation} Bu saldırıyı çalıştırmak için gereken python3 betiği eksik. Lütfen \"\${normal_color}downgrade_attack.py\${red_color}\" dosyasının mevcut olduğundan ve plugins klasöründe \"\${normal_color}downgrade_attack.sh\${red_color}\" dosyasının yanında bulunduğundan emin ol"
	arr["ARABIC","downgrade_attack_3"]="\${pending_of_translation} سكربت python3 المطلوب لتشغيل هذا الهجوم غير موجود. يرجى التأكد من وجود الملف \"\${normal_color}downgrade_attack.py\${red_color}\" في مجلد الإضافات بجانب الملف \"\${normal_color}downgrade_attack.sh\${red_color}\""
	arr["CHINESE","downgrade_attack_3"]="\${pending_of_translation} 运行此攻击所需的 python3 脚本缺失。请确保文件 \"\${normal_color}downgrade_attack.py\${red_color}\" 存在，并位于插件目录中 \"\${normal_color}downgrade_attack.sh\${red_color}\" 文件旁边"
}

function downgrade_attack_python3_script_validation() {

	if ! [ -f "${scriptfolder}${plugins_dir}downgrade_attack.py" ]; then
		echo
		language_strings "${language}" "downgrade_attack_3" "red"
		language_strings "${language}" 115 "read"
		return 1
	fi
	return 0
}

function downgrade_attack_python3_validation() {

	if ! hash python3 2> /dev/null; then
		if ! hash python 2> /dev/null; then
			echo
			language_strings "${language}" "downgrade_attack_2" "red"
			language_strings "${language}" 115 "read"
			return 1
		else
			local python_major
			local python_minor
			local python_version_raw
			python_version_raw=$(python -V 2>&1)
			if [[ "${python_version_raw}" =~ ([0-9]+)\.([0-9]+) ]]; then
				python_major="${BASH_REMATCH[1]}"
				python_minor="${BASH_REMATCH[2]}"
			else
				python_major=0
				python_minor=0
			fi
			if [[ "${python_major}" -lt 3 ]] || { [[ "${python_major}" -eq 3 ]] && [[ "${python_minor}" -lt 6 ]]; }; then
				echo
				language_strings "${language}" "downgrade_attack_2" "red"
				language_strings "${language}" 115 "read"
				return 1
			fi
			python3="python"
		fi
	else
		local python_major
		local python_minor
		local python_version_raw
		python_version_raw=$(python3 -V 2>&1)
		if [[ "${python_version_raw}" =~ ([0-9]+)\.([0-9]+) ]]; then
			python_major="${BASH_REMATCH[1]}"
			python_minor="${BASH_REMATCH[2]}"
		else
			python_major=0
			python_minor=0
		fi
		if [[ "${python_major}" -lt 3 ]] || { [[ "${python_major}" -eq 3 ]] && [[ "${python_minor}" -lt 6 ]]; }; then
			echo
			language_strings "${language}" "downgrade_attack_2" "red"
			language_strings "${language}" 115 "read"
			return 1
		fi
		python3="python3"
	fi
	return 0
}

function downgrade_attack_option() {

	debug_print

	get_aircrack_version
	if ! validate_aircrack_wpa3_version; then
		echo
		language_strings "${language}" 763 "red"
		language_strings "${language}" 115 "read"
		return 1
	fi
	if ! downgrade_attack_python3_validation; then return 1; fi
	if ! downgrade_attack_python3_script_validation; then return 1; fi

	if [[ -z ${bssid} ]] || [[ -z ${essid} ]] || [[ -z ${channel} ]]; then
		echo
		language_strings "${language}" 125 "yellow"
		language_strings "${language}" 115 "read"
		if ! explore_for_targets_option "WPA3"; then return 1; fi
	fi
	if ! check_monitor_enabled "${interface}"; then
		echo
		language_strings "${language}" 14 "red"
		language_strings "${language}" 115 "read"
		return 1
	fi
	if ! validate_wpa3_network; then return 1; fi
	if ! validate_network_type "personal"; then return 1; fi

	echo
	language_strings "${language}" "downgrade_attack_1" "blue"
	echo
	language_strings "${language}" 32 "green"
	echo
	language_strings "${language}" 33 "yellow"
	language_strings "${language}" 4 "read"

	exec_downgrade_attack
}

function exec_downgrade_attack() {

	debug_print

	iw dev "${interface}" set channel "${channel}" > /dev/null 2>&1
	recalculate_windows_sizes
	manage_output "+j -bg \"#000000\" -fg \"#FFC0CB\" -geometry ${g1_topright_window} -T \"WPA3 Group Downgrade Attack\"" "${python3} ${scriptfolder}${plugins_dir}downgrade_attack.py ${bssid} ${channel} ${interface} ${language}" "WPA3 Group Downgrade Attack" "active"

	if ! wait_for_process "${python3} ${scriptfolder}${plugins_dir}downgrade_attack.py ${bssid} ${channel} ${interface} ${language}" "WPA3 Group Downgrade Attack"; then
		return 1
	fi
}
