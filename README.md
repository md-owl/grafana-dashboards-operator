# Grafana Dashboards

## Adding a new dashboard

### Adding JSON

To add a new dashboard, create a file with the dashboard code in the json folder.

### Adding manifest

To apply the dashboard in a Grafana instance, create a file with the .yaml extension in the dashboards folder:

```
apiVersion: grafana.integreatly.org/v1beta1
kind: GrafanaDashboard
metadata:
  name: <dashboard-name>
  namespace: monitoring
  labels:
    app: grafana
spec:
  folder: <folder-name>
  instanceSelector:
    matchLabels:
      dashboards: "grafana"
  configMapRef:
    name: dashboards
    key: <dashboard-name>.json
```

Where "dashboard-name" is a short name for the dashboard in lowercase without spaces (for example, loki-dashboard), matching the name of the .json file from the json directory,
"folder-name" is the name of the folder where the dashboard will be placed.

Then add the dashboard file name to dashboards/kustomization.yaml:

```
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
resources:
  - loki.yaml
  ...
  - yourfile.yaml
```

Where "yourfile.yaml" is the name of the created dashboard file in the repository.

### Adding manifest to grafana-pub

To display the dashboard in the public Grafana instance (grafana-pub), create a file with the .yaml extension in the public-dashboards folder, similar to the files in the dashboards folder:

```
apiVersion: grafana.integreatly.org/v1beta1
kind: GrafanaDashboard
metadata:
  name: <dashboard-name>-pub
  namespace: monitoring
  labels:
    app: grafana-pub
spec:
  instanceSelector:
    matchLabels:
      dashboards: "grafana-pub"
  configMapRef:
    name: dashboards
    key: <dashboard-name>.json
```

Where "dashboard-name" is a short name for the dashboard in lowercase without spaces (for example, loki-dashboard), matching the name of the .json file from the json directory.

The key difference is the "-pub" suffix - without it, the dashboard will not be deployed to the public instance.

Then add the dashboard file name to public-dashboards/kustomization.yaml:

```
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
resources:
  - loki.yaml
  ...
  - yourfile.yaml
```

Where "yourfile.yaml" is the name of the created dashboard file in the repository.

## Installing a plugin

If a custom plugin is required for the dashboard, first find it in the Grafana plugin catalog (https://grafana.com/grafana/plugins/), then add its name and version to your dashboard in the spec section:

```
spec:
  instanceSelector:
    matchLabels:
      dashboards: "grafana"
  plugins:
    - name: "volkovlabs-echarts-panel"
      version: "7.2.4"
  json: |
    ...
```

## List of dashboard folders

| Folder name | Description |
|-------------|-------------|
| applications | folder for product service dashboards |
| infrastructure | folder for infrastructure and resource dashboards |
| logs | folder for log dashboards |

## Terraform Overview

Terraform is used to automatically create Kubernetes ConfigMaps from JSON dashboard files. It scans the `json` directory and creates a ConfigMap with all dashboard JSON files as data keys.

The Terraform configuration:
- Uses the Kubernetes provider to connect to the cluster
- Creates a ConfigMap named "dashboards" in the "monitoring" namespace
- Loads all `.json` files from the `../json` directory
- Each JSON file becomes a key-value pair in the ConfigMap

This automation ensures dashboards are always available in the cluster for the Grafana operator to use.