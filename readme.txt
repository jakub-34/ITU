Všetky pre projekt zaujímavé súbory sa nachádzajú na adrese ./itu_app/lib/, kde frontend sa nachádza v súbore views.

Jakub Hrdlička (xhrdli18):
main_screen.dart
nontemplate_session_screen.dart
session_screen.dart

Tomáš Zgút (xzgutt00):
main_screen.dart
session_screen.dart
add_job_screen.dart
add_session_screen.dart
add_nontemplate_session_screen.dart

Súbory, ktoré sa zhodujú sú rozdelené komponentou "Divider", ktorá rozdeluje aplikáciu na dve časti, a tiež aj autorstvo kódu - nad "Dividrom" Jakub Hrdlička, pod "Dividrom" Tomáš Žgút. Pre lepšie rozdelenie viď komentáre.

Návod na spustenie:
    Prerekvizity:
        - nainštalované flutter sdk (https://docs.flutter.dev/get-started/install)
        - nainštalované andorid studio (https://developer.android.com/studio), odporúčaný je flutter plugin
        - vytvorené zariadenie v anroid studiu
    Pred spustením:
        - cd jobtracker
        - flutter create --platforms ios,android .
    Spustenie:
        - zapnúť vytvorené zariadenie v andorid studiu (alebo flutter emulators --launch <nazov zariadenia>)
        - flutter run
