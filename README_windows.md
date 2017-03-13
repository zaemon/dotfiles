README(windows)
================

Windowsでbash環境を作る際の注意事項。

terminal
----------------

- minttyをGit-Bashで使う

環境変数
----------------

- minttyをGit-Bashで使う場合、パスの優先順位を正しくしないと文字化けする。
    - 上位: /usr/bin , /usr/local/bin
    - 下位: /c/MinGW/bin , /c/MinGW/msys/*/bin/

VS Code設定
----------------

設定ファイルは以下にあるのでリンクする。
- AppData/Roaming/Code/User/settings.json

