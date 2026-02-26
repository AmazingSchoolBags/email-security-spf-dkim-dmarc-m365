# Header check (Gmail)

1) Envoyer un email depuis `@settat.fr` vers une adresse Gmail.
2) Ouvrir le mail → menu “⋮” → “Afficher l’original”.

Attendu :

- **SPF: PASS**
- **DKIM: PASS**
- **DMARC: PASS**

Si DMARC fail :
- vérifier l’alignement (From domain vs domain DKIM/SPF)
- vérifier la policy DMARC et la propagation DNS
