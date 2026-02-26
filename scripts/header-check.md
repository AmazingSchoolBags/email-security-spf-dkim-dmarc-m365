
---

## 4) docs/troubleshooting.md

```md
# Troubleshooting

## Erreur DKIM : ADObjectAlreadyExistsException

Message type :
`Microsoft.Exchange.Data.Directory.ADObjectAlreadyExistsException`

### Symptôme
Lors du clic “Enable/Activer DKIM” dans Exchange Admin Center, une erreur apparaît indiquant qu’un objet existe déjà.

### Cause probable
L’objet/config DKIM a déjà été créé côté Microsoft (AD interne), et la tentative de création/activation réécrit une config existante.

### Résolution recommandée
1) Vérifier dans Exchange Admin Center :
- Domaine : `settat.fr`
- Statut : **Activé**
- Valid : **OK**

2) Vérifier la présence DNS :
- CNAME selector1/selector2 résolvent correctement.

3) Vérifier en conditions réelles :
- Envoi email test → Headers → DKIM = PASS

Conclusion :
- Si DNS + état EAC + headers OK, l’erreur peut être ignorée.
