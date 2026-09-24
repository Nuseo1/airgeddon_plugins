#!/usr/bin/env bash

# =============================================================================
# airgeddon Plugin: custom_et_control.sh
# Manual Evil Twin Control
# IMPORTANT: This file MUST be named exactly "custom_et_control.sh"
# =============================================================================

#shellcheck disable=SC2034,SC2154

plugin_name="Manual Evil Twin Control"
plugin_description="Plugin for manually selecting the BSSID, channel, and ESSID for Evil Twin attacks."
plugin_author="Nuseo1"
plugin_enabled=1
plugin_minimum_ag_affected_version="12.02"
plugin_maximum_ag_affected_version=""
plugin_distros_supported=("*")

type -t debug_print >/dev/null || function debug_print() { :; }

declare -g custom_et_chosen_bssid=""
declare -g custom_et_chosen_essid=""

# ----------------------------------------------------------------------
# Language hook
# ----------------------------------------------------------------------
function custom_et_control_prehook_hookable_for_languages() {
	arr["ENGLISH","custom_et_text_1"]="Manual Evil Twin control:"
	arr["SPANISH","custom_et_text_1"]="Control manual de Evil Twin:"
	arr["FRENCH","custom_et_text_1"]="\${pending_of_translation} Contrôle manuel Evil Twin :"
	arr["CATALAN","custom_et_text_1"]="\${pending_of_translation} Control manual d'Evil Twin:"
	arr["PORTUGUESE","custom_et_text_1"]="\${pending_of_translation} Controle manual de Evil Twin:"
	arr["RUSSIAN","custom_et_text_1"]="\${pending_of_translation} Ручное управление Evil Twin:"
	arr["GREEK","custom_et_text_1"]="\${pending_of_translation} Χειροκίνητος έλεγχος Evil Twin:"
	arr["ITALIAN","custom_et_text_1"]="\${pending_of_translation} Controllo manuale di Evil Twin:"
	arr["POLISH","custom_et_text_1"]="\${pending_of_translation} Ręczna kontrola Evil Twin:"
	arr["GERMAN","custom_et_text_1"]="Manuelle Evil Twin Kontrolle:"
	arr["TURKISH","custom_et_text_1"]="\${pending_of_translation} Manuel Evil Twin kontrolü:"
	arr["ARABIC","custom_et_text_1"]="\${pending_of_translation} التحكم اليدوي في Evil Twin:"
	arr["CHINESE","custom_et_text_1"]="\${pending_of_translation} Evil Twin 手动控制："

	arr["ENGLISH","custom_et_text_2"]="How should the BSSID for the Evil Twin be set?"
	arr["SPANISH","custom_et_text_2"]="¿Cómo se debe configurar el BSSID para el Evil Twin?"
	arr["FRENCH","custom_et_text_2"]="\${pending_of_translation} Comment définir le BSSID pour l'Evil Twin ?"
	arr["CATALAN","custom_et_text_2"]="\${pending_of_translation} Com s'ha d'establir el BSSID per a l'Evil Twin?"
	arr["PORTUGUESE","custom_et_text_2"]="\${pending_of_translation} Como o BSSID para o Evil Twin deve ser definido?"
	arr["RUSSIAN","custom_et_text_2"]="\${pending_of_translation} Как следует установить BSSID для Evil Twin?"
	arr["GREEK","custom_et_text_2"]="\${pending_of_translation} Πώς πρέπει να ρυθμιστεί το BSSID για το Evil Twin;"
	arr["ITALIAN","custom_et_text_2"]="\${pending_of_translation} Come dovrebbe essere impostato il BSSID per l'Evil Twin?"
	arr["POLISH","custom_et_text_2"]="\${pending_of_translation} Jak ustawić BSSID dla Evil Twin?"
	arr["GERMAN","custom_et_text_2"]="Wie soll die BSSID für den Evil Twin festgelegt werden?"
	arr["TURKISH","custom_et_text_2"]="\${pending_of_translation} Evil Twin için BSSID nasıl ayarlanmalı?"
	arr["ARABIC","custom_et_text_2"]="\${pending_of_translation} كيف يجب تعيين BSSID لـ Evil Twin؟"
	arr["CHINESE","custom_et_text_2"]="\${pending_of_translation} 应该如何设置 Evil Twin 的 BSSID？"

	arr["ENGLISH","custom_et_text_3"]="Use exact original BSSID"
	arr["SPANISH","custom_et_text_3"]="Usar el BSSID original exacto"
	arr["FRENCH","custom_et_text_3"]="\${pending_of_translation} Utiliser le BSSID original exact"
	arr["CATALAN","custom_et_text_3"]="\${pending_of_translation} Utilitzar el BSSID original exacte"
	arr["PORTUGUESE","custom_et_text_3"]="\${pending_of_translation} Usar o BSSID original exato"
	arr["RUSSIAN","custom_et_text_3"]="\${pending_of_translation} Использовать точный исходный BSSID"
	arr["GREEK","custom_et_text_3"]="\${pending_of_translation} Χρησιμοποιήστε το ακριβές αρχικό BSSID"
	arr["ITALIAN","custom_et_text_3"]="\${pending_of_translation} Usa l'esatto BSSID originale"
	arr["POLISH","custom_et_text_3"]="\${pending_of_translation} Użyj dokładnego oryginalnego BSSID"
	arr["GERMAN","custom_et_text_3"]="Exakte originale BSSID verwenden"
	arr["TURKISH","custom_et_text_3"]="\${pending_of_translation} Tam orijinal BSSID'yi kullan"
	arr["ARABIC","custom_et_text_3"]="\${pending_of_translation} استخدام BSSID الأصلي بالضبط"
	arr["CHINESE","custom_et_text_3"]="\${pending_of_translation} 使用确切的原始 BSSID"

	arr["ENGLISH","custom_et_text_4"]="Enter a completely new BSSID manually"
	arr["SPANISH","custom_et_text_4"]="Introducir un BSSID completamente nuevo manualmente"
	arr["FRENCH","custom_et_text_4"]="\${pending_of_translation} Entrer manuellement un nouveau BSSID"
	arr["CATALAN","custom_et_text_4"]="\${pending_of_translation} Introduir manualment un BSSID completament nou"
	arr["PORTUGUESE","custom_et_text_4"]="\${pending_of_translation} Inserir manualmente um BSSID completamente novo"
	arr["RUSSIAN","custom_et_text_4"]="\${pending_of_translation} Ввести совершенно новый BSSID вручную"
	arr["GREEK","custom_et_text_4"]="\${pending_of_translation} Εισαγάγετε ένα εντελώς νέο BSSID χειροκίνητα"
	arr["ITALIAN","custom_et_text_4"]="\${pending_of_translation} Inserisci manualmente un BSSID completamente nuovo"
	arr["POLISH","custom_et_text_4"]="\${pending_of_translation} Wprowadź całkowicie nowy BSSID ręcznie"
	arr["GERMAN","custom_et_text_4"]="Eine komplett neue BSSID manuell eingeben"
	arr["TURKISH","custom_et_text_4"]="\${pending_of_translation} Tamamen yeni bir BSSID'yi manuel gir"
	arr["ARABIC","custom_et_text_4"]="\${pending_of_translation} إدخال BSSID جديد تمامًا يدويًا"
	arr["CHINESE","custom_et_text_4"]="\${pending_of_translation} 手动输入一个全新的 BSSID"

	arr["ENGLISH","custom_et_text_5"]="Use standard (slightly modified) airgeddon BSSID (default)"
	arr["SPANISH","custom_et_text_5"]="Usar BSSID estándar (ligeramente modificado) de airgeddon (predeterminado)"
	arr["FRENCH","custom_et_text_5"]="\${pending_of_translation} Utiliser le BSSID standard (légèrement modifié) d'airgeddon (par défaut)"
	arr["CATALAN","custom_et_text_5"]="\${pending_of_translation} Utilitzar el BSSID estàndard (lleugerament modificat) d'airgeddon (predeterminat)"
	arr["PORTUGUESE","custom_et_text_5"]="\${pending_of_translation} Usar o BSSID padrão (ligeiramente modificado) do airgeddon (padrão)"
	arr["RUSSIAN","custom_et_text_5"]="\${pending_of_translation} Использовать стандартный (слегка изменённый) BSSID airgeddon (по умолчанию)"
	arr["GREEK","custom_et_text_5"]="\${pending_of_translation} Χρησιμοποιήστε το τυπικό (ελαφρώς τροποποιημένο) BSSID του airgeddon (προεπιλογή)"
	arr["ITALIAN","custom_et_text_5"]="\${pending_of_translation} Usa il BSSID standard (leggermente modificato) di airgeddon (predefinito)"
	arr["POLISH","custom_et_text_5"]="\${pending_of_translation} Użyj standardowego (lekko zmodyfikowanego) BSSID airgeddon (domyślnie)"
	arr["GERMAN","custom_et_text_5"]="Standard (leicht veränderte) airgeddon BSSID verwenden (Standard)"
	arr["TURKISH","custom_et_text_5"]="\${pending_of_translation} Standart (hafif değiştirilmiş) airgeddon BSSID kullan (varsayılan)"
	arr["ARABIC","custom_et_text_5"]="\${pending_of_translation} استخدام BSSID الافتراضي (المعدل قليلاً) لـ airgeddon (الافتراضي)"
	arr["CHINESE","custom_et_text_5"]="\${pending_of_translation} 使用标准（稍作修改的）airgeddon BSSID（默认）"

	arr["ENGLISH","custom_et_text_6"]="OK. Original BSSID will be used:"
	arr["SPANISH","custom_et_text_6"]="OK. Se utilizará el BSSID original:"
	arr["FRENCH","custom_et_text_6"]="\${pending_of_translation} OK. Le BSSID original sera utilisé :"
	arr["CATALAN","custom_et_text_6"]="\${pending_of_translation} OK. S'utilitzarà el BSSID original:"
	arr["PORTUGUESE","custom_et_text_6"]="\${pending_of_translation} OK. O BSSID original será usado:"
	arr["RUSSIAN","custom_et_text_6"]="\${pending_of_translation} ОК. Будет использован исходный BSSID:"
	arr["GREEK","custom_et_text_6"]="\${pending_of_translation} OK. Το αρχικό BSSID θα χρησιμοποιηθεί:"
	arr["ITALIAN","custom_et_text_6"]="\${pending_of_translation} OK. Verrà utilizzato il BSSID originale:"
	arr["POLISH","custom_et_text_6"]="\${pending_of_translation} OK. Zostanie użyty oryginalny BSSID:"
	arr["GERMAN","custom_et_text_6"]="OK. Die originale BSSID wird verwendet:"
	arr["TURKISH","custom_et_text_6"]="\${pending_of_translation} Tamam. Orijinal BSSID kullanılacak:"
	arr["ARABIC","custom_et_text_6"]="\${pending_of_translation} حسنا. سيتم استخدام BSSID الأصلي:"
	arr["CHINESE","custom_et_text_6"]="\${pending_of_translation} 好的。将使用原始 BSSID："

	arr["ENGLISH","custom_et_text_7"]="Warning: This may cause instability in the network!"
	arr["SPANISH","custom_et_text_7"]="Advertencia: ¡Esto puede causar inestabilidad en la red!"
	arr["FRENCH","custom_et_text_7"]="\${pending_of_translation} Attention : cela peut provoquer une instabilité du réseau!"
	arr["CATALAN","custom_et_text_7"]="\${pending_of_translation} Atenció: Això pot causar inestabilitat a la xarxa!"
	arr["PORTUGUESE","custom_et_text_7"]="\${pending_of_translation} Aviso: Isso pode causar instabilidade na rede!"
	arr["RUSSIAN","custom_et_text_7"]="\${pending_of_translation} Предупреждение: Это может вызвать нестабильность сети!"
	arr["GREEK","custom_et_text_7"]="\${pending_of_translation} Προειδοποίηση: Αυτό μπορεί να προκαλέσει αστάθεια στο δίκτυο!"
	arr["ITALIAN","custom_et_text_7"]="\${pending_of_translation} Avviso: Questo potrebbe causare instabilità nella rete!"
	arr["POLISH","custom_et_text_7"]="\${pending_of_translation} Ostrzeżenie: Może to spowodować niestabilność w sieci!"
	arr["GERMAN","custom_et_text_7"]="Achtung: Dies kann zu Instabilität im Netzwerk führen!"
	arr["TURKISH","custom_et_text_7"]="\${pending_of_translation} Uyarı: Bu ağda kararsızlığa neden olabilir!"
	arr["ARABIC","custom_et_text_7"]="\${pending_of_translation} تحذير: قد يسبب هذا عدم استقرار في الشبكة!"
	arr["CHINESE","custom_et_text_7"]="\${pending_of_translation} 警告：这可能会导致网络不稳定！"

	arr["ENGLISH","custom_et_text_8"]="Please enter the desired BSSID (format XX:XX:XX:XX:XX:XX):"
	arr["SPANISH","custom_et_text_8"]="Introduzca el BSSID deseado (formato XX:XX:XX:XX:XX:XX):"
	arr["FRENCH","custom_et_text_8"]="\${pending_of_translation} Veuillez entrer le BSSID souhaité (format XX:XX:XX:XX:XX:XX):"
	arr["CATALAN","custom_et_text_8"]="\${pending_of_translation} Introduïu el BSSID desitjat (format XX:XX:XX:XX:XX:XX):"
	arr["PORTUGUESE","custom_et_text_8"]="\${pending_of_translation} Insira o BSSID desejado (formato XX:XX:XX:XX:XX:XX):"
	arr["RUSSIAN","custom_et_text_8"]="\${pending_of_translation} Пожалуйста, введите желаемый BSSID (формат XX:XX:XX:XX:XX:XX):"
	arr["GREEK","custom_et_text_8"]="\${pending_of_translation} Παρακαλώ εισαγάγετε το επιθυμητό BSSID (μορφή XX:XX:XX:XX:XX:XX):"
	arr["ITALIAN","custom_et_text_8"]="\${pending_of_translation} Inserisci il BSSID desiderato (formato XX:XX:XX:XX:XX:XX):"
	arr["POLISH","custom_et_text_8"]="\${pending_of_translation} Wprowadź żądany BSSID (format XX:XX:XX:XX:XX:XX):"
	arr["GERMAN","custom_et_text_8"]="Geben Sie die gewünschte BSSID ein (Format XX:XX:XX:XX:XX:XX):"
	arr["TURKISH","custom_et_text_8"]="\${pending_of_translation} Lütfen istenen BSSID'yi girin (biçim XX:XX:XX:XX:XX:XX):"
	arr["ARABIC","custom_et_text_8"]="\${pending_of_translation} الرجاء إدخال BSSID المطلوب (بالتنسيق XX:XX:XX:XX:XX:XX):"
	arr["CHINESE","custom_et_text_8"]="\${pending_of_translation} 请输入所需的 BSSID（格式 XX:XX:XX:XX:XX:XX）："

	arr["ENGLISH","custom_et_text_9"]="BSSID has been set to:"
	arr["SPANISH","custom_et_text_9"]="BSSID se ha configurado a:"
	arr["FRENCH","custom_et_text_9"]="\${pending_of_translation} Le BSSID a été défini sur :"
	arr["CATALAN","custom_et_text_9"]="\${pending_of_translation} El BSSID s'ha establert a:"
	arr["PORTUGUESE","custom_et_text_9"]="\${pending_of_translation} O BSSID foi definido para:"
	arr["RUSSIAN","custom_et_text_9"]="\${pending_of_translation} BSSID был установлен на:"
	arr["GREEK","custom_et_text_9"]="\${pending_of_translation} Το BSSID έχει οριστεί σε:"
	arr["ITALIAN","custom_et_text_9"]="\${pending_of_translation} Il BSSID è stato impostato su:"
	arr["POLISH","custom_et_text_9"]="\${pending_of_translation} BSSID został ustawiony na:"
	arr["GERMAN","custom_et_text_9"]="BSSID wurde gesetzt auf:"
	arr["TURKISH","custom_et_text_9"]="\${pending_of_translation} BSSID şu olarak ayarlandı:"
	arr["ARABIC","custom_et_text_9"]="\${pending_of_translation} تم تعيين BSSID إلى:"
	arr["CHINESE","custom_et_text_9"]="\${pending_of_translation} BSSID 已设置为："

	arr["ENGLISH","custom_et_text_10"]="Invalid format. Generating standard BSSID..."
	arr["SPANISH","custom_et_text_10"]="Formato no válido. Generando BSSID estándar..."
	arr["FRENCH","custom_et_text_10"]="\${pending_of_translation} Format invalide. Génération du BSSID standard..."
	arr["CATALAN","custom_et_text_10"]="\${pending_of_translation} Format no vàlid. Generant BSSID estàndard..."
	arr["PORTUGUESE","custom_et_text_10"]="\${pending_of_translation} Formato inválido. Gerando BSSID padrão..."
	arr["RUSSIAN","custom_et_text_10"]="\${pending_of_translation} Неверный формат. Генерация стандартного BSSID..."
	arr["GREEK","custom_et_text_10"]="\${pending_of_translation} Μη έγκυρη μορφή. Δημιουργία τυπικού BSSID..."
	arr["ITALIAN","custom_et_text_10"]="\${pending_of_translation} Formato non valido. Generazione del BSSID standard..."
	arr["POLISH","custom_et_text_10"]="\${pending_of_translation} Nieprawidłowy format. Generowanie standardowego BSSID..."
	arr["GERMAN","custom_et_text_10"]="Ungültiges Format. Standard-BSSID wird generiert..."
	arr["TURKISH","custom_et_text_10"]="\${pending_of_translation} Geçersiz biçim. Standart BSSID oluşturuluyor..."
	arr["ARABIC","custom_et_text_10"]="\${pending_of_translation} تنسيق غير صالح. جارٍ إنشاء BSSID الافتراضي..."
	arr["CHINESE","custom_et_text_10"]="\${pending_of_translation} 格式无效。正在生成标准 BSSID..."

	arr["ENGLISH","custom_et_text_11"]="OK. Standard airgeddon BSSID will be used."
	arr["SPANISH","custom_et_text_11"]="OK. Se utilizará el BSSID estándar de airgeddon"
	arr["FRENCH","custom_et_text_11"]="\${pending_of_translation} OK. Le BSSID standard d'airgeddon sera utilisé."
	arr["CATALAN","custom_et_text_11"]="\${pending_of_translation} OK. S'utilitzarà el BSSID estàndard d'airgeddon."
	arr["PORTUGUESE","custom_et_text_11"]="\${pending_of_translation} OK. O BSSID padrão do airgeddon será usado."
	arr["RUSSIAN","custom_et_text_11"]="\${pending_of_translation} ОК. Будет использован стандартный BSSID airgeddon."
	arr["GREEK","custom_et_text_11"]="\${pending_of_translation} OK. Θα χρησιμοποιηθεί το τυπικό BSSID του airgeddon."
	arr["ITALIAN","custom_et_text_11"]="\${pending_of_translation} OK. Verrà utilizzato il BSSID standard di airgeddon."
	arr["POLISH","custom_et_text_11"]="\${pending_of_translation} OK. Zostanie użyty standardowy BSSID airgeddon."
	arr["GERMAN","custom_et_text_11"]="OK. Die Standard airgeddon BSSID wird verwendet."
	arr["TURKISH","custom_et_text_11"]="\${pending_of_translation} Tamam. Standart airgeddon BSSID kullanılacak."
	arr["ARABIC","custom_et_text_11"]="\${pending_of_translation} حسنا. سيتم استخدام BSSID الافتراضي لـ airgeddon."
	arr["CHINESE","custom_et_text_11"]="\${pending_of_translation} 好的。将使用标准 airgeddon BSSID。"

	arr["ENGLISH","custom_et_text_12"]="Current channel:"
	arr["SPANISH","custom_et_text_12"]="Canal actual:"
	arr["FRENCH","custom_et_text_12"]="\${pending_of_translation} Canal actuel:"
	arr["CATALAN","custom_et_text_12"]="\${pending_of_translation} Canal actual:"
	arr["PORTUGUESE","custom_et_text_12"]="\${pending_of_translation} Canal atual:"
	arr["RUSSIAN","custom_et_text_12"]="\${pending_of_translation} Текущий канал:"
	arr["GREEK","custom_et_text_12"]="\${pending_of_translation} Τρέχον κανάλι:"
	arr["ITALIAN","custom_et_text_12"]="\${pending_of_translation} Canale attuale:"
	arr["POLISH","custom_et_text_12"]="\${pending_of_translation} Aktualny kanał:"
	arr["GERMAN","custom_et_text_12"]="Aktueller Kanal:"
	arr["TURKISH","custom_et_text_12"]="\${pending_of_translation} Geçerli kanal:"
	arr["ARABIC","custom_et_text_12"]="\${pending_of_translation} القناة الحالية:"
	arr["CHINESE","custom_et_text_12"]="\${pending_of_translation} 当前信道："

	arr["ENGLISH","custom_et_text_12b"]="Enter a new channel (e.g. 1-233) or press Enter to keep it:"
	arr["SPANISH","custom_et_text_12b"]="Introduzca un nuevo canal (ej. 1-233) o presione Intro para mantenerlo:"
	arr["FRENCH","custom_et_text_12b"]="\${pending_of_translation} Entrez un nouveau canal (par ex. 1-233) ou appuyez sur Entrée pour le conserver:"
	arr["CATALAN","custom_et_text_12b"]="\${pending_of_translation} Introduïu un canal nou (p. ex. 1-233) o premeu Enter per mantenir-lo:"
	arr["PORTUGUESE","custom_et_text_12b"]="\${pending_of_translation} Digite um novo canal (ex. 1-233) ou pressione Enter para mantê-lo:"
	arr["RUSSIAN","custom_et_text_12b"]="\${pending_of_translation} Введите новый канал (например, 1-233) или нажмите Enter, чтобы оставить его:"
	arr["GREEK","custom_et_text_12b"]="\${pending_of_translation} Εισαγάγετε νέο κανάλι (π.χ. 1-233) ή πατήστε Enter για να το κρατήσετε:"
	arr["ITALIAN","custom_et_text_12b"]="\${pending_of_translation} Inserisci un nuovo canale (es. 1-233) o premi Invio per mantenerlo:"
	arr["POLISH","custom_et_text_12b"]="\${pending_of_translation} Wprowadź nowy kanał (np. 1-233) lub naciśnij Enter, aby go zachować:"
	arr["GERMAN","custom_et_text_12b"]="Geben Sie einen neuen Kanal (z.B. 1-233) ein oder drücken Sie Enter, um ihn beizubehalten:"
	arr["TURKISH","custom_et_text_12b"]="\${pending_of_translation} Yeni bir kanal girin (örn. 1-233) veya korumak için Enter'a basın:"
	arr["ARABIC","custom_et_text_12b"]="\${pending_of_translation} أدخل قناة جديدة (مثلاً 1-233) أو اضغط Enter للاحتفاظ بها:"
	arr["CHINESE","custom_et_text_12b"]="\${pending_of_translation} 输入新信道（例如 1-233）或按回车键保持不变："

	arr["ENGLISH","custom_et_text_13"]="Channel has been set to:"
	arr["SPANISH","custom_et_text_13"]="El canal se configuró a:"
	arr["FRENCH","custom_et_text_13"]="\${pending_of_translation} Le canal a été défini sur:"
	arr["CATALAN","custom_et_text_13"]="\${pending_of_translation} El canal s'ha establert a:"
	arr["PORTUGUESE","custom_et_text_13"]="\${pending_of_translation} O canal foi definido para:"
	arr["RUSSIAN","custom_et_text_13"]="\${pending_of_translation} Канал установлен на:"
	arr["GREEK","custom_et_text_13"]="\${pending_of_translation} Το κανάλι έχει οριστεί σε:"
	arr["ITALIAN","custom_et_text_13"]="\${pending_of_translation} Il canale è stato impostato su:"
	arr["POLISH","custom_et_text_13"]="\${pending_of_translation} Kanał został ustawiony na:"
	arr["GERMAN","custom_et_text_13"]="Kanal wurde gesetzt auf:"
	arr["TURKISH","custom_et_text_13"]="\${pending_of_translation} Kanal şu olarak ayarlandı:"
	arr["ARABIC","custom_et_text_13"]="\${pending_of_translation} تم تعيين القناة إلى:"
	arr["CHINESE","custom_et_text_13"]="\${pending_of_translation} 信道已设置为："

	arr["ENGLISH","custom_et_text_14"]="Keeping standard channel:"
	arr["SPANISH","custom_et_text_14"]="Manteniendo el canal estándar:"
	arr["FRENCH","custom_et_text_14"]="\${pending_of_translation} Conservation du canal standard:"
	arr["CATALAN","custom_et_text_14"]="\${pending_of_translation} Es manté el canal estàndard:"
	arr["PORTUGUESE","custom_et_text_14"]="\${pending_of_translation} Mantendo o canal padrão:"
	arr["RUSSIAN","custom_et_text_14"]="\${pending_of_translation} Сохранение стандартного канала:"
	arr["GREEK","custom_et_text_14"]="\${pending_of_translation} Διατήρηση τυπικού καναλιού:"
	arr["ITALIAN","custom_et_text_14"]="\${pending_of_translation} Mantenimento del canale standard:"
	arr["POLISH","custom_et_text_14"]="\${pending_of_translation} Zachowanie standardowego kanału:"
	arr["GERMAN","custom_et_text_14"]="Standard-Kanal wird verwendet:"
	arr["TURKISH","custom_et_text_14"]="\${pending_of_translation} Standart kanal korunuyor:"
	arr["ARABIC","custom_et_text_14"]="\${pending_of_translation} الاحتفاظ بالقناة القياسية:"
	arr["CHINESE","custom_et_text_14"]="\${pending_of_translation} 保持标准信道："

	arr["ENGLISH","custom_et_text_15"]="How should the ESSID (AP name) for the Evil Twin be set?"
	arr["SPANISH","custom_et_text_15"]="¿Cómo se debe configurar el ESSID (nombre del AP) para el Evil Twin?"
	arr["FRENCH","custom_et_text_15"]="\${pending_of_translation} Comment définir l'ESSID (nom AP) pour l'Evil Twin?"
	arr["CATALAN","custom_et_text_15"]="\${pending_of_translation} Com s'ha d'establir l'ESSID (nom AP) per a l'Evil Twin?"
	arr["PORTUGUESE","custom_et_text_15"]="\${pending_of_translation} Como o ESSID (nome AP) para o Evil Twin deve ser definido?"
	arr["RUSSIAN","custom_et_text_15"]="\${pending_of_translation} Как должен быть установлен ESSID (имя AP) для Evil Twin?"
	arr["GREEK","custom_et_text_15"]="\${pending_of_translation} Πώς πρέπει να ρυθμιστεί το ESSID (όνομα AP) για το Evil Twin;"
	arr["ITALIAN","custom_et_text_15"]="\${pending_of_translation} Come dovrebbe essere impostato l'ESSID (nome AP) per l'Evil Twin?"
	arr["POLISH","custom_et_text_15"]="\${pending_of_translation} Jak ustawić ESSID (nazwę AP) dla Evil Twin?"
	arr["GERMAN","custom_et_text_15"]="Wie soll die ESSID (AP-Name) für den Evil Twin festgelegt werden?"
	arr["TURKISH","custom_et_text_15"]="\${pending_of_translation} Evil Twin için ESSID (AP adı) nasıl ayarlanmalı?"
	arr["ARABIC","custom_et_text_15"]="\${pending_of_translation} كيف يجب تعيين ESSID (اسم نقطة الوصول) لـ Evil Twin؟"
	arr["CHINESE","custom_et_text_15"]="\${pending_of_translation} 应该如何设置 Evil Twin 的 ESSID（AP名称）？"

	arr["ENGLISH","custom_et_text_16"]="Use exact original ESSID"
	arr["SPANISH","custom_et_text_16"]="Usar el ESSID original exacto"
	arr["FRENCH","custom_et_text_16"]="\${pending_of_translation} Utiliser l'ESSID original exact"
	arr["CATALAN","custom_et_text_16"]="\${pending_of_translation} Utilitzar l'ESSID original exacte"
	arr["PORTUGUESE","custom_et_text_16"]="\${pending_of_translation} Usar o ESSID original exato"
	arr["RUSSIAN","custom_et_text_16"]="\${pending_of_translation} Использовать точный исходный ESSID"
	arr["GREEK","custom_et_text_16"]="\${pending_of_translation} Χρησιμοποιήστε το ακριβές αρχικό ESSID"
	arr["ITALIAN","custom_et_text_16"]="\${pending_of_translation} Usa l'esatto ESSID originale"
	arr["POLISH","custom_et_text_16"]="\${pending_of_translation} Użyj dokładnego oryginalnego ESSID"
	arr["GERMAN","custom_et_text_16"]="Exakte originale ESSID verwenden"
	arr["TURKISH","custom_et_text_16"]="\${pending_of_translation} Tam orijinal ESSID'yi kullan"
	arr["ARABIC","custom_et_text_16"]="\${pending_of_translation} استخدام ESSID الأصلي بالضبط"
	arr["CHINESE","custom_et_text_16"]="\${pending_of_translation} 使用确切的原始 ESSID"

	arr["ENGLISH","custom_et_text_17"]="Enter a new ESSID manually"
	arr["SPANISH","custom_et_text_17"]="Introducir un nuevo ESSID manualmente"
	arr["FRENCH","custom_et_text_17"]="\${pending_of_translation} Entrer manuellement un nouvel ESSID"
	arr["CATALAN","custom_et_text_17"]="\${pending_of_translation} Introduir manualment un nou ESSID"
	arr["PORTUGUESE","custom_et_text_17"]="\${pending_of_translation} Inserir manualmente um novo ESSID"
	arr["RUSSIAN","custom_et_text_17"]="\${pending_of_translation} Ввести новый ESSID вручную"
	arr["GREEK","custom_et_text_17"]="\${pending_of_translation} Εισαγάγετε ένα νέο ESSID χειροκίνητα"
	arr["ITALIAN","custom_et_text_17"]="\${pending_of_translation} Inserisci manualmente un nuovo ESSID"
	arr["POLISH","custom_et_text_17"]="\${pending_of_translation} Wprowadź nowy ESSID ręcznie"
	arr["GERMAN","custom_et_text_17"]="Eine neue ESSID manuell eingeben"
	arr["TURKISH","custom_et_text_17"]="\${pending_of_translation} Yeni bir ESSID'yi manuel gir"
	arr["ARABIC","custom_et_text_17"]="\${pending_of_translation} إدخال ESSID جديد يدويًا"
	arr["CHINESE","custom_et_text_17"]="\${pending_of_translation} 手动输入新的 ESSID"

	arr["ENGLISH","custom_et_text_18"]="Use standard airgeddon ESSID (default)"
	arr["SPANISH","custom_et_text_18"]="Usar ESSID estándar de airgeddon (predeterminado)"
	arr["FRENCH","custom_et_text_18"]="\${pending_of_translation} Utiliser l'ESSID standard d'airgeddon (par défaut)"
	arr["CATALAN","custom_et_text_18"]="\${pending_of_translation} Utilitzar l'ESSID estàndard d'airgeddon (predeterminat)"
	arr["PORTUGUESE","custom_et_text_18"]="\${pending_of_translation} Usar o ESSID padrão do airgeddon (padrão)"
	arr["RUSSIAN","custom_et_text_18"]="\${pending_of_translation} Использовать стандартный ESSID airgeddon (по умолчанию)"
	arr["GREEK","custom_et_text_18"]="\${pending_of_translation} Χρησιμοποιήστε το τυπικό ESSID του airgeddon (προεπιλογή)"
	arr["ITALIAN","custom_et_text_18"]="\${pending_of_translation} Usa l'ESSID standard di airgeddon (predefinito)"
	arr["POLISH","custom_et_text_18"]="\${pending_of_translation} Użyj standardowego ESSID airgeddon (domyślnie)"
	arr["GERMAN","custom_et_text_18"]="Standard airgeddon ESSID verwenden (Standard)"
	arr["TURKISH","custom_et_text_18"]="\${pending_of_translation} Standart airgeddon ESSID kullan (varsayılan)"
	arr["ARABIC","custom_et_text_18"]="\${pending_of_translation} استخدام ESSID الافتراضي لـ airgeddon (الافتراضي)"
	arr["CHINESE","custom_et_text_18"]="\${pending_of_translation} 使用标准  airgeddon ESSID（默认）"

	arr["ENGLISH","custom_et_text_19"]="OK. Exact original ESSID will be used:"
	arr["SPANISH","custom_et_text_19"]="OK. Se utilizará el ESSID original:"
	arr["FRENCH","custom_et_text_19"]="\${pending_of_translation} OK. L'ESSID original sera utilisé :"
	arr["CATALAN","custom_et_text_19"]="\${pending_of_translation} OK. S'utilitzarà l'ESSID original:"
	arr["PORTUGUESE","custom_et_text_19"]="\${pending_of_translation} OK. O ESSID original será usado:"
	arr["RUSSIAN","custom_et_text_19"]="\${pending_of_translation} ОК. Будет использован исходный ESSID:"
	arr["GREEK","custom_et_text_19"]="\${pending_of_translation} OK. Το αρχικό ESSID θα χρησιμοποιηθεί:"
	arr["ITALIAN","custom_et_text_19"]="\${pending_of_translation} OK. Verrà utilizzato l'ESSID originale:"
	arr["POLISH","custom_et_text_19"]="\${pending_of_translation} OK. Zostanie użyty oryginalny ESSID:"
	arr["GERMAN","custom_et_text_19"]="OK. Die originale ESSID wird verwendet:"
	arr["TURKISH","custom_et_text_19"]="\${pending_of_translation} Tamam. Orijinal ESSID kullanılacak:"
	arr["ARABIC","custom_et_text_19"]="\${pending_of_translation} حسنا. سيتم استخدام ESSID الأصلي:"
	arr["CHINESE","custom_et_text_19"]="\${pending_of_translation} 好的。将使用原始 ESSID："

	arr["ENGLISH","custom_et_text_20"]="Please enter the desired ESSID (cannot be empty):"
	arr["SPANISH","custom_et_text_20"]="Introduzca el ESSID deseado (no puede estar vacío):"
	arr["FRENCH","custom_et_text_20"]="\${pending_of_translation} Veuillez entrer l'ESSID souhaité (ne peut pas être vide):"
	arr["CATALAN","custom_et_text_20"]="\${pending_of_translation} Introduïu l'ESSID desitjat (no pot estar buit):"
	arr["PORTUGUESE","custom_et_text_20"]="\${pending_of_translation} Insira o ESSID desejado (não pode estar vazio):"
	arr["RUSSIAN","custom_et_text_20"]="\${pending_of_translation} Пожалуйста, введите желаемый ESSID (не может быть пустым):"
	arr["GREEK","custom_et_text_20"]="\${pending_of_translation} Παρακαλώ εισαγάγετε το επιθυμητό ESSID (δεν μπορεί να είναι κενό):"
	arr["ITALIAN","custom_et_text_20"]="\${pending_of_translation} Inserisci l'ESSID desiderato (non può essere vuoto):"
	arr["POLISH","custom_et_text_20"]="\${pending_of_translation} Wprowadź żądany ESSID (nie może być pusty):"
	arr["GERMAN","custom_et_text_20"]="Geben Sie die gewünschte ESSID ein (darf nicht leer sein):"
	arr["TURKISH","custom_et_text_20"]="\${pending_of_translation} Lütfen istenen ESSID'yi girin (boş olamaz):"
	arr["ARABIC","custom_et_text_20"]="\${pending_of_translation} الرجاء إدخال ESSID المطلوب (لا يمكن أن يكون فارغًا):"
	arr["CHINESE","custom_et_text_20"]="\${pending_of_translation} 请输入所需的 ESSID（不能为空）："

	arr["ENGLISH","custom_et_text_21"]="ESSID has been set to:"
	arr["SPANISH","custom_et_text_21"]="ESSID se ha configurado en:"
	arr["FRENCH","custom_et_text_21"]="\${pending_of_translation} L'ESSID a été défini sur :"
	arr["CATALAN","custom_et_text_21"]="\${pending_of_translation} L'ESSID s'ha establert a:"
	arr["PORTUGUESE","custom_et_text_21"]="\${pending_of_translation} O ESSID foi definido para:"
	arr["RUSSIAN","custom_et_text_21"]="\${pending_of_translation} ESSID был установлен на:"
	arr["GREEK","custom_et_text_21"]="\${pending_of_translation} Το ESSID έχει οριστεί σε:"
	arr["ITALIAN","custom_et_text_21"]="\${pending_of_translation} L'ESSID è stato impostato su:"
	arr["POLISH","custom_et_text_21"]="\${pending_of_translation} ESSID został ustawiony na:"
	arr["GERMAN","custom_et_text_21"]="ESSID wurde gesetzt auf:"
	arr["TURKISH","custom_et_text_21"]="\${pending_of_translation} ESSID şu olarak ayarlandı:"
	arr["ARABIC","custom_et_text_21"]="\${pending_of_translation} تم تعيين ESSID إلى:"
	arr["CHINESE","custom_et_text_21"]="\${pending_of_translation} ESSID 已设置为："

	arr["ENGLISH","custom_et_text_22"]="No input. Generating standard ESSID..."
	arr["SPANISH","custom_et_text_22"]="Sin entrada. Generando ESSID estándar..."
	arr["FRENCH","custom_et_text_22"]="\${pending_of_translation} Aucune saisie. Génération de l'ESSID standard..."
	arr["CATALAN","custom_et_text_22"]="\${pending_of_translation} Sense entrada. Generant ESSID estàndard..."
	arr["PORTUGUESE","custom_et_text_22"]="\${pending_of_translation} Sem entrada. Gerando ESSID padrão..."
	arr["RUSSIAN","custom_et_text_22"]="\${pending_of_translation} Нет ввода. Генерация стандартного ESSID..."
	arr["GREEK","custom_et_text_22"]="\${pending_of_translation} Καμία εισαγωγή. Δημιουργία τυπικού ESSID..."
	arr["ITALIAN","custom_et_text_22"]="\${pending_of_translation} Nessun input. Generazione dell'ESSID standard..."
	arr["POLISH","custom_et_text_22"]="\${pending_of_translation} Brak danych. Generowanie standardowego ESSID..."
	arr["GERMAN","custom_et_text_22"]="Keine Eingabe. Standard-ESSID wird generiert..."
	arr["TURKISH","custom_et_text_22"]="\${pending_of_translation} Giriş yok. Standart ESSID oluşturuluyor..."
	arr["ARABIC","custom_et_text_22"]="\${pending_of_translation} لا يوجد إدخال. جارٍ إنشاء ESSID الافتراضي..."
	arr["CHINESE","custom_et_text_22"]="\${pending_of_translation} 无输入。正在生成标准 ESSID..."

	arr["ENGLISH","custom_et_text_23"]="OK. Standard airgeddon ESSID will be used."
	arr["SPANISH","custom_et_text_23"]="OK. Se utilizará el ESSID estándar de airgeddon"
	arr["FRENCH","custom_et_text_23"]="\${pending_of_translation} OK. L'ESSID standard d'airgeddon sera utilisé."
	arr["CATALAN","custom_et_text_23"]="\${pending_of_translation} OK. S'utilitzarà l'ESSID estàndard d'airgeddon."
	arr["PORTUGUESE","custom_et_text_23"]="\${pending_of_translation} OK. O ESSID padrão do airgeddon será usado."
	arr["RUSSIAN","custom_et_text_23"]="\${pending_of_translation} ОК. Будет использован стандартный ESSID airgeddon."
	arr["GREEK","custom_et_text_23"]="\${pending_of_translation} OK. Θα χρησιμοποιηθεί το τυπικό ESSID του airgeddon."
	arr["ITALIAN","custom_et_text_23"]="\${pending_of_translation} OK. Verrà utilizzato l'ESSID standard di airgeddon."
	arr["POLISH","custom_et_text_23"]="\${pending_of_translation} OK. Zostanie użyty standardowy ESSID airgeddon."
	arr["GERMAN","custom_et_text_23"]="OK. Die Standard airgeddon ESSID wird verwendet."
	arr["TURKISH","custom_et_text_23"]="\${pending_of_translation} Tamam. Standart airgeddon ESSID kullanılacak."
	arr["ARABIC","custom_et_text_23"]="\${pending_of_translation} حسنا. سيتم استخدام ESSID الافتراضي لـ airgeddon."
	arr["CHINESE","custom_et_text_23"]="\${pending_of_translation} 好的。将使用标准 airgeddon ESSID。"

	arr["ENGLISH","custom_et_text_24"]="Note: Changing channel means DoS won't work simultaneously on original channel."
	arr["SPANISH","custom_et_text_24"]="Nota: Cambiar de canal significa que el DoS no funcionará simultáneamente en el canal original"
	arr["FRENCH","custom_et_text_24"]="\${pending_of_translation} Note : Changer de canal signifie que le DoS ne fonctionnera pas simultanément sur le canal d'origine."
	arr["CATALAN","custom_et_text_24"]="\${pending_of_translation} Nota: Canviar de canal significa que DoS no funcionarà simultàniament al canal original."
	arr["PORTUGUESE","custom_et_text_24"]="\${pending_of_translation} Nota: Mudar de canal significa que o DoS não funcionará simultaneamente no canal original."
	arr["RUSSIAN","custom_et_text_24"]="\${pending_of_translation} Примечание: Смена канала означает, что DoS не будет работать одновременно на исходном канале."
	arr["GREEK","custom_et_text_24"]="\${pending_of_translation} Σημείωση: Η αλλαγή καναλιού σημαίνει ότι το DoS δεν θα λειτουργεί ταυτόχρονα στο αρχικό κανάλι."
	arr["ITALIAN","custom_et_text_24"]="\${pending_of_translation} Nota: Cambiare canale significa che il DoS non funzionerà simultaneamente sul canale originale."
	arr["POLISH","custom_et_text_24"]="\${pending_of_translation} Uwaga: Zmiana kanału oznacza, że DoS nie będzie działał jednocześnie na oryginalnym kanale."
	arr["GERMAN","custom_et_text_24"]="Hinweis: Kanalwechsel bedeutet, dass DoS nicht gleichzeitig auf Originalkanal funktioniert."
	arr["TURKISH","custom_et_text_24"]="\${pending_of_translation} Not: Kanalı değiştirmek, DoS'un orijinal kanalda eşzamanlı çalışmayacağı anlamına gelir."
	arr["ARABIC","custom_et_text_24"]="\${pending_of_translation} ملاحظة: تغيير القناة يعني أن هجوم DoS لن يعمل في نفس الوقت على القناة الأصلية."
	arr["CHINESE","custom_et_text_24"]="\${pending_of_translation} 注意：更改信道意味着 DoS 将不会在原始信道上同时工作。"

	arr["ENGLISH","custom_et_text_25"]="Which band does this channel belong to?"
	arr["SPANISH","custom_et_text_25"]="¿A qué banda pertenece este canal?"
	arr["FRENCH","custom_et_text_25"]="\${pending_of_translation} À quelle bande appartient ce canal?"
	arr["CATALAN","custom_et_text_25"]="\${pending_of_translation} A quina banda pertany aquest canal?"
	arr["PORTUGUESE","custom_et_text_25"]="\${pending_of_translation} A qual banda este canal pertence?"
	arr["RUSSIAN","custom_et_text_25"]="\${pending_of_translation} К какому диапазону относится этот канал?"
	arr["GREEK","custom_et_text_25"]="\${pending_of_translation} Σε ποια ζώνη ανήκει αυτό το κανάλι;"
	arr["ITALIAN","custom_et_text_25"]="\${pending_of_translation} A quale banda appartiene questo canale?"
	arr["POLISH","custom_et_text_25"]="\${pending_of_translation} Do którego pasma należy ten kanał?"
	arr["GERMAN","custom_et_text_25"]="Zu welchem Band gehört dieser Kanal?"
	arr["TURKISH","custom_et_text_25"]="\${pending_of_translation} Bu kanal hangi banda ait?"
	arr["ARABIC","custom_et_text_25"]="\${pending_of_translation} إلى أي نطاق تنتمي هذه القناة؟"
	arr["CHINESE","custom_et_text_25"]="\${pending_of_translation} 此信道属于哪个频段？"
}

# ----------------------------------------------------------------------
# Interactive prompt (helper function)
# ----------------------------------------------------------------------
function custom_et_control_interactive_prompt() {
	debug_print
	local lang_key="${language}"
	if [[ -z "${arr["${lang_key}","custom_et_text_1"]}" ]]; then
		lang_key="ENGLISH"
	fi
	custom_et_chosen_bssid=""
	custom_et_chosen_essid=""

	echo
	echo -e "${yellow_color}${arr["${lang_key}","custom_et_text_1"]}${normal_color}"
	echo
	echo -e "${cyan_color}${arr["${lang_key}","custom_et_text_2"]}${normal_color}"
	echo -e "1. ${arr["${lang_key}","custom_et_text_3"]} (${bssid})"
	echo -e "2. ${arr["${lang_key}","custom_et_text_4"]}"
	echo -e "3. ${arr["${lang_key}","custom_et_text_5"]}"
	read -rp "> " bssid_choice

	case "${bssid_choice}" in
		1)
			custom_et_chosen_bssid="${bssid}"
			echo -e "${green_color}${arr["${lang_key}","custom_et_text_6"]} ${custom_et_chosen_bssid}${normal_color}"
			echo -e "${red_color}${arr["${lang_key}","custom_et_text_7"]}${normal_color}"
			;;
		2)
			echo -e "${green_color}${arr["${lang_key}","custom_et_text_8"]}${normal_color}"
			read -rp "> " custom_bssid
			if [[ -n "${custom_bssid}" && "${custom_bssid}" =~ ^([0-9A-Fa-f]{2}:){5}[0-9A-Fa-f]{2}$ ]]; then
				custom_et_chosen_bssid="${custom_bssid}"
				echo -e "${green_color}${arr["${lang_key}","custom_et_text_9"]} ${custom_et_chosen_bssid}${normal_color}"
			else
				echo -e "${red_color}${arr["${lang_key}","custom_et_text_10"]}${normal_color}"
			fi
			;;
		*)
			echo -e "${green_color}${arr["${lang_key}","custom_et_text_11"]}${normal_color}"
			;;
	esac

	echo
	echo -e "${cyan_color}${arr["${lang_key}","custom_et_text_12"]} ${channel}${normal_color}"
	echo -e "${red_color}${arr["${lang_key}","custom_et_text_24"]}${normal_color}"
	echo -e "${cyan_color}${arr["${lang_key}","custom_et_text_12b"]}${normal_color}"
	read -rp "> " custom_channel

	if [[ -n "${custom_channel}" && "${custom_channel}" =~ ^[0-9]+$ && "${custom_channel}" -gt 0 && "${custom_channel}" -le 233 ]]; then
		channel="${custom_channel}"
		echo "${channel}" > "${tmpdir}${channelfile}"
		echo -e "${green_color}${arr["${lang_key}","custom_et_text_13"]} ${channel}${normal_color}"
		echo
		echo -e "${cyan_color}${arr["${lang_key}","custom_et_text_25"]}${normal_color}"
		echo "1. 2.4Ghz"
		echo "2. 5Ghz"
		echo "3. 6Ghz"
		local valid_band=0
		while [[ ${valid_band} -eq 0 ]]; do
			read -rp "> " custom_band_choice
			case "${custom_band_choice}" in
				1) band="${band_24ghz}"; target_band_id="${band_24ghz}"; valid_band=1 ;;
				2) band="${band_5ghz}"; target_band_id="${band_5ghz}"; valid_band=1 ;;
				3) band="${band_6ghz}"; target_band_id="${band_6ghz}"; valid_band=1 ;;
				*) echo -e "${red_color}Invalid / Ungültig${normal_color}" ;;
			esac
		done
		echo "${target_band_id}" > "${tmpdir}${bandfile}"
		echo -e "${green_color}Band -> ${band}${normal_color}"
	else
		echo -e "${green_color}${arr["${lang_key}","custom_et_text_14"]} ${channel}${normal_color}"
	fi

	echo
	echo -e "${cyan_color}${arr["${lang_key}","custom_et_text_15"]}${normal_color}"
	echo -e "1. ${arr["${lang_key}","custom_et_text_16"]} (${essid})"
	echo -e "2. ${arr["${lang_key}","custom_et_text_17"]}"
	echo -e "3. ${arr["${lang_key}","custom_et_text_18"]}"
	read -rp "> " essid_choice

	case "${essid_choice}" in
		1)
			custom_et_chosen_essid="${essid}"
			echo -e "${green_color}${arr["${lang_key}","custom_et_text_19"]} \"${essid}\"${normal_color}"
			;;
		2)
			local custom_essid=""
			echo -e "${green_color}${arr["${lang_key}","custom_et_text_20"]}${normal_color}"
			while [[ -z "${custom_essid}" ]]; do
				read -r -p "> " custom_essid
			done
			custom_et_chosen_essid="${custom_essid}"
			echo -e "${green_color}${arr["${lang_key}","custom_et_text_21"]} \"${custom_essid}\"${normal_color}"
			;;
		*)
			custom_et_chosen_essid="${essid}"
			echo -e "${green_color}${arr["${lang_key}","custom_et_text_23"]} \"${essid}\"${normal_color}"
			;;
	esac

	echo
	sleep 2

	if [[ -n "${custom_et_chosen_essid}" ]]; then
		et_essid="${custom_et_chosen_essid}"
	fi
	if [[ -n "${custom_et_chosen_bssid}" ]]; then
		et_bssid="${custom_et_chosen_bssid}"
	fi
}

# ----------------------------------------------------------------------
# Prehooks
# ----------------------------------------------------------------------
function custom_et_control_prehook_set_hostapd_config() {
	debug_print
	custom_et_control_interactive_prompt
}

function custom_et_control_prehook_set_hostapd_wpe_config() {
	debug_print
	custom_et_control_interactive_prompt
}

function custom_et_control_prehook_set_hostapd_mana_config() {
	debug_print
	custom_et_control_interactive_prompt
}

# ----------------------------------------------------------------------
# Config application (helper function)
# ----------------------------------------------------------------------
function custom_et_control_apply_config() {
	local target_config_file="${1}"

	if [[ -n "${custom_et_chosen_bssid}" ]]; then
		et_bssid="${custom_et_chosen_bssid}"
		sed -ri "s/^bssid=.*/bssid=${et_bssid}/" "${target_config_file}" 2> /dev/null
	fi

	if [[ -n "${custom_et_chosen_essid}" ]]; then
		et_essid="${custom_et_chosen_essid}"
		local safe_essid
		safe_essid=$(printf '%s' "${et_essid}" | sed -e 's/\\/\\\\/g' -e 's/|/\\|/g' -e 's/&/\\&/g')
		sed -ri "s|^ssid=.*|ssid=${safe_essid}|" "${target_config_file}" 2> /dev/null
	fi
}

# ----------------------------------------------------------------------
# Posthooks
# ----------------------------------------------------------------------
function custom_et_control_posthook_set_hostapd_config() {
	custom_et_control_apply_config "${tmpdir}${hostapd_file}"
}

function custom_et_control_posthook_set_hostapd_wpe_config() {
	custom_et_control_apply_config "${tmpdir}${hostapd_wpe_file}"
}

function custom_et_control_posthook_set_hostapd_mana_config() {
	custom_et_control_apply_config "${tmpdir}${hostapd_mana_file}"
}

# ----------------------------------------------------------------------
# Webserver Prehook
# ----------------------------------------------------------------------
function custom_et_control_prehook_launch_webserver() {
	if [[ -n "${custom_et_chosen_essid}" ]] && [[ "${custom_et_chosen_essid}" != "${essid}" ]]; then
		local portal_index="${tmpdir}${webdir}${indexfile}"
		if [[ -f "${portal_index}" ]]; then
			local safe_old_essid
			safe_old_essid=$(printf '%s' "${essid}" | sed 's/[][\\/.*^$]/\\&/g')
			local safe_new_essid
			safe_new_essid=$(printf '%s' "${custom_et_chosen_essid}" | sed -e 's/[\\/&]/\\&/g')
			sed -i "s/${safe_old_essid}/${safe_new_essid}/g" "${portal_index}" 2> /dev/null
		fi
	fi
}
