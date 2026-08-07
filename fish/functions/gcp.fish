function gcp -d "Switch gcloud configuration"
    if test (count $argv) -eq 0
        # No args: show current config and list all
        set -l active (gcloud config configurations list --filter="is_active=true" --format="value(name)" 2>/dev/null)
        echo "Active: $active"
        echo ""
        gcloud config configurations list --format="table(name,is_active,account,project)" 2>/dev/null
        return
    end

    switch $argv[1]
        case ls list
            gcloud config configurations list --format="table(name,is_active,account,project)" 2>/dev/null
        case '*'
            gcloud config configurations activate $argv[1] 2>/dev/null
            if test $status -eq 0
                set -l project (gcloud config get-value project 2>/dev/null)
                set -l account (gcloud config get-value account 2>/dev/null)
                echo "Switched to: $argv[1] ($account / $project)"
            else
                echo "Configuration '$argv[1]' not found. Available:"
                gcloud config configurations list --format="value(name)" 2>/dev/null
            end
    end
end
