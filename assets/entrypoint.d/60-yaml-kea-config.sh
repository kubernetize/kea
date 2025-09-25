
# This script converts the Kea configuration from YAML to JSON format.
# It checks for the existence of a .yaml configuration file and converts it
# to the JSON format expected by Kea if the JSON configuration is not already present.

if [ ! -f "${KEA_CONFIG}" -a -f "${KEA_CONFIG}.yaml" ]; then
    echo "[=] Converting ${KEA_CONFIG}.yaml to ${KEA_CONFIG}"
    yq --output-format json "${KEA_CONFIG}.yaml" > "${KEA_CONFIG}.json"
    mv "${KEA_CONFIG}.json" "${KEA_CONFIG}"
fi
