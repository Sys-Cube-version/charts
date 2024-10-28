#!/bin/bash

# Nom du chart
CHART_NAME="agent-looping"
CHART_REPO_PATH="charts"  # le dossier du dépôt GitHub

# Étape 1 : Demander la nouvelle version ou l'incrémenter automatiquement
echo "Entrez la nouvelle version du chart (ou laissez vide pour garder la version actuelle) :"
read NEW_VERSION

if [[ -n "$NEW_VERSION" ]]; then
    # Remplacer la version dans Chart.yaml
    sed -i "s/^version: .*/version: $NEW_VERSION/" ./$CHART_NAME/Chart.yaml
    echo "Version mise à jour dans Chart.yaml : $NEW_VERSION"
else
    echo "Pas de mise à jour de la version."
fi

# Étape 2 : Packager le chart
echo "Packaging le chart Helm..."
helm package ./$CHART_NAME --destination $CHART_REPO_PATH

# Étape 3 : Mettre à jour l'index.yaml avec la nouvelle URL
echo "Mise à jour de l'index.yaml avec charts.sys-cube.com..."
helm repo index $CHART_REPO_PATH --url https://charts.sys-cube.com

# Étape 4 : Commit et push vers GitHub
cd $CHART_REPO_PATH
echo "Commit des changements..."
git add .
git commit -m "Mise à jour du chart $CHART_NAME à la version $NEW_VERSION"
echo "Push vers le dépôt GitHub..."
git push

echo "Publication terminée !"
