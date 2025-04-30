import re
from pyswip import Prolog

prolog = Prolog()
prolog.consult("grammar_correction.pl")

ozne_duzeltme = {
    'i': 'i', 'you': 'you', 'he': 'he', 'she': 'she', 'it': 'it',
    'we': 'we', 'they': 'they', 'me': 'i', 'my': 'i', 'mine': 'i',
    'her': 'she', 'him': 'he', 'us': 'we', 'them': 'they',
    'our': 'we', 'their': 'they'
}

ozne_listesi = {'i', 'you', 'he', 'she', 'it', 'we', 'they'}

# Basit fiil listesi (Prolog sisteminle uyumlu)
fiil_listesi = {'go', 'like', 'eat', 'play', 'read', 'walk', 'study', 'write', 'watch'}

def cumleye_ayir_baglamli(paragraf):
    kelimeler = paragraf.strip().lower().split()
    cümleler = []
    cümle = []

    i = 0
    while i < len(kelimeler):
        kelime = kelimeler[i]
        duzeltilmis = ozne_duzeltme.get(kelime)

        # Sonraki kelime var mı?
        sonraki_kelime = kelimeler[i + 1] if i + 1 < len(kelimeler) else None

        if (
            duzeltilmis in ozne_listesi
            and sonraki_kelime in fiil_listesi
            and cümle
        ):
            cümleler.append(' '.join(cümle))
            cümle = [kelime]
        else:
            cümle.append(kelime)

        i += 1

    if cümle:
        cümleler.append(' '.join(cümle))

    return cümleler





print("📘 Gramer Düzeltici Chatbot (Paragraf için çalışır, çıkmak için 'exit' yaz)\n")

while True:
    paragraf = input("👤 Paragraf girin: ").lower()
    if paragraf.strip() in ['exit', 'quit', 'çık']:
        print("👋 Görüşmek üzere!")
        break

    cumleler = cumleye_ayir_baglamli(paragraf)

    duzeltilmisler = []
    geri_bildirimler = []

    for cumle in cumleler:
        kelimeler = cumle.split()
        if len(kelimeler) < 3:
            duzeltilmisler.append(cumle)
            geri_bildirimler.append("⚠️ Eksik yapı: " + cumle)
            continue

        ozne, fiil, *nesne = kelimeler
        nesne_str = ' '.join(nesne)

        try:
            query = f"cumle_dogrula_geri_bildirim({ozne}, {fiil}, '{nesne_str}', C, G)."
            sonuc = list(prolog.query(query))

            if sonuc:
                duzeltilmisler.append(sonuc[0]["C"])
                geri_bildirimler.append(sonuc[0]["G"])
            else:
                duzeltilmisler.append(cumle)
                geri_bildirimler.append("❌ Kural bulunamadı: " + cumle)

        except Exception as e:
            duzeltilmisler.append(cumle)
            geri_bildirimler.append("⚠️ Hata: " + str(e))

    print("\n✅ Düzeltilmiş Paragraf:\n" + '. '.join(duzeltilmisler) + '.')
    print("\n🧾 Geri Bildirimler:")
    for gb in geri_bildirimler:
        print("-", gb)
    print()
