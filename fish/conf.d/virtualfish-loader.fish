set -g VIRTUALFISH_VERSION 2.5.5
set -g VIRTUALFISH_PYTHON_EXEC /usr/local/opt/python@3.11/bin/python3.11
source /usr/local/lib/python3.11/site-packages/virtualfish/virtual.fish
source /usr/local/lib/python3.11/site-packages/virtualfish/auto_activation.fish
source /usr/local/lib/python3.11/site-packages/virtualfish/projects.fish
emit virtualfish_did_setup_plugins