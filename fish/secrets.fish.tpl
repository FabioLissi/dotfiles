# Template for ~/.config/fish/secrets.fish — contains NO secrets, safe to commit.
# Run `secrets_sync` to render it via 1Password (`op inject`).
# Item names must match your 1Password vault entries.
set -gx OPENROUTER_API_KEY "{{ op://Private/OpenRouter API Key/credential }}"
set -gx HF_TOKEN "{{ op://Private/Hugging Face Token/credential }}"
