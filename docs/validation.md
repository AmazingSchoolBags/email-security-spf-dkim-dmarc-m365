# Validation — SPF / DKIM / DMARC

## 1) Vérifier DKIM (CNAME)

Windows / PowerShell :

```powershell
nslookup -type=CNAME selector1._domainkey.settat.fr
nslookup -type=CNAME selector2._domainkey.settat.fr
