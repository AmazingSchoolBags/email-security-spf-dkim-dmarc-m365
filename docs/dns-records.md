# DNS Records — settat.fr

## MX (Microsoft 365)

- Type : MX
- Host/Name : `@` (ou `settat.fr`)
- Priority : 0
- Value : `settat-fr.mail.protection.outlook.com`

## Autodiscover

- Type : CNAME
- Host/Name : `autodiscover`
- Value : `autodiscover.outlook.com`

## SPF

- Type : TXT
- Host/Name : `@` (ou `settat.fr`)
- Value :
`v=spf1 include:spf.protection.outlook.com -all`

Notes :
- Un seul enregistrement SPF (pas de doublons).
- `-all` si l’envoi se fait uniquement via M365.

## DKIM

Deux CNAME à publier (valeurs fournies par Microsoft 365) :

- Type : CNAME
- Host/Name : `selector1._domainkey`
- Value : `selector1-settat-fr._domainkey.ksll.r-v1.dkim.mail.microsoft`

- Type : CNAME
- Host/Name : `selector2._domainkey`
- Value : `selector2-settat-fr._domainkey.ksll.r-v1.dkim.mail.microsoft`

## DMARC

- Type : TXT
- Host/Name : `_dmarc`
- Value :
`v=DMARC1; p=quarantine; pct=100; rua=mailto:postmaster@settat.fr; fo=1`

Option stricte (après monitoring) :
`v=DMARC1; p=reject; pct=100; rua=mailto:postmaster@settat.fr; fo=1`
