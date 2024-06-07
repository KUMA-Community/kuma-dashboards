
* 14.08.2023 - добавлен импорт экспорт Пресетов

! выберите после импорта тип дашборта Universal в веб-интерфейсе KUMA

Параметры запуска скрипта kuma_(imEX)port_dash_preset.sh
     -exportDash "<Dashboard Name>" </path/File Export Name.json> -- export dashboard to file in JSON (dashboard name must be UNIQUE! and use " if spaces are in the name)
     -importDash <File Export Name.json> -- import dashboard to KUMA
     -deleteDash "<Dashboard Name>" -- delete dashboard from KUMA (dashboard name must be UNIQUE! and use " if spaces are in the name)
     -exportPreset "<Preset Name>" </path/File Export Name.json> -- export Preset to file in JSON (dashboard name must be UNIQUE! and use " if spaces are in the name)
     -importPreset <File Export Name.json> -- import Preset to KUMA



Предварительно нужно поместить mongoexport и mongoimport из  https://box.kaspersky.com/d/53acc02f7a3c4d89a327/  в папку /opt/kaspersky/kuma/mongodb/bin/ и сделать chmod +x по этим файлам (chmod +x /opt/kaspersky/kuma/mongodb/bin/*).
Затем использовать скрипт (ему тоже надо chmod +x)
При импорте-экспорте нужно указывать полный путем, пример, /root/DNS_EXPORT_CLEAR.json
Имена дашбордов при экспорте должны быть без пробелов.

Для работы скрипта потребуется утилита uuidgen. (Если нет утилиты, то apt-get install uuid-runtime)

Пример импорта:
./kuma_\(imEX\)port_dash.sh -import /root/CheckPointCEF_EXPORT_CLEAR(kuma2-0).json

Иногда после импорта требуется зайти в новый дашборд в режиме редактирования и проверить указаны ли во всех виджетах верные хранилища, затем сохранить и снова обновить.