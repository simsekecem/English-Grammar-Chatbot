import re
from pyswip import Prolog

prolog = Prolog()
prolog.consult("grammar_correction.pl")

def cumleye_ayir_akilli(paragraf):
    kelimeler = paragraf.strip().lower().split()
    cümleler = []
    cümle = []
    özneler = {'i', 'you', 'he', 'she', 'it', 'we', 'they', 'me', 'him', 'her', 'us', 'them'}

    for kelime in kelimeler:
        # Eğer yeni bir cümle başlıyorsa
        if kelime in özneler and cümle:
            cümleler.append(' '.join(cümle))
            cümle = [kelime]
        else:
            cümle.append(kelime)

    if cümle:
        cümleler.append(' '.join(cümle))

    return cümleler


print("📘 Gramer Düzeltici Chatbot (Paragraf için çalışır, çıkmak için 'exit' yaz)\n")

while True:
    paragraf = input("👤 Paragraf girin: ").lower()
    if paragraf.strip() in ['exit', 'quit', 'çık']:
        print("👋 Görüşmek üzere!")
        break

    cumleler = cumleye_ayir_akilli(paragraf)

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
