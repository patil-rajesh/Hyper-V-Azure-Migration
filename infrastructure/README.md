## Deploy Azure Resources

```powershell
az deployment group create `
  --resource-group HyperVLab `
  --template-file template.json `
  --parameters parameters.json
``
