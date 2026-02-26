# Microsoft 365 Email Authentication (SPF / DKIM / DMARC) — settat.fr

Ce repo documente la mise en conformité et le durcissement de l’authentification email pour un domaine hébergé sur **Microsoft 365 / Exchange Online**.

Objectifs :
- Améliorer la **délivrabilité** (Gmail/Outlook)
- Réduire le risque de **spoofing** (usurpation d’adresse)
- Mettre en place une configuration standard : **SPF + DKIM + DMARC**
- Fournir une méthode **reproductible** (DNS + validation + troubleshooting)

---

## Contexte

- Domaine : `settat.fr`
- Provider email : Microsoft 365 (Exchange Online)
- DNS : gestion via registrar (zone DNS)
- Vérifications : `nslookup`, outils de diagnostic MX/DMARC

---

## Résumé de la configuration

### SPF (TXT)
- Autorise l’envoi via Microsoft 365 :
`v=spf1 include:spf.protection.outlook.com -all`

### DKIM (CNAME + activation M365)
- Ajout des CNAME selector1/selector2
- Activation DKIM dans Exchange Admin Center

### DMARC (TXT)
- Politique initiale : `p=quarantine` (mise en quarantaine / spam)
- Rapports : `rua=mailto:postmaster@settat.fr`
- Déploiement à 100% : `pct=100`

---

## DNS Records (quick view)

> Voir le détail : [docs/dns-records.md](docs/dns-records.md)

- MX : `settat-fr.mail.protection.outlook.com` (pref 0)
- CNAME : `autodiscover` → `autodiscover.outlook.com`
- TXT SPF : `v=spf1 include:spf.protection.outlook.com -all`
- CNAME DKIM :
  - `selector1._domainkey` → `selector1-settat-fr._domainkey.ksll.r-v1.dkim.mail.microsoft`
  - `selector2._domainkey` → `selector2-settat-fr._domainkey.ksll.r-v1.dkim.mail.microsoft`
- TXT DMARC :
  - `_dmarc` → `v=DMARC1; p=quarantine; pct=100; rua=mailto:postmaster@settat.fr; fo=1`

---

## Validation

- DNS : `nslookup` (CNAME DKIM + TXT DMARC)
- Envoi test + analyse des headers : SPF/DKIM/DMARC = PASS
- Outils de vérification MX/DMARC (captures dans `docs/screenshots/`)

> Voir : [docs/validation.md](docs/validation.md)

---

## Automatisation

Script PowerShell de checks DNS :
- `scripts/nslookup-checks.ps1`

---

## Troubleshooting (cas réel)

Erreur rencontrée lors de l’activation DKIM :
- `Microsoft.Exchange.Data.Directory.ADObjectAlreadyExistsException`
- Interprétation : l’objet/config DKIM existe déjà côté Microsoft, l’activation peut rester valide.
- Résolution : validation via état DKIM dans EAC + vérification DNS + headers.

> Voir : [docs/troubleshooting.md](docs/troubleshooting.md)

---

## Next steps (optionnel)

- Passer DMARC de `quarantine` → `reject` après période de monitoring (2–3 semaines)
- Mettre en place **MTA-STS** et **TLS-RPT** (durcissement transport TLS)

---

## Auteur

Mohamed Chaouay  
(Infra / Cloud / M365 / Sécurité)
