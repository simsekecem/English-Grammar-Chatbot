from pyswip import Prolog
import re

prolog = Prolog()
prolog.consult("grammar_correction.pl")

print("📘 Gramer Düzeltici Chatbot (Çıkmak için 'exit' yaz)\n")


def yer_dogrulama(nesne):
    return bool(re.match(r'^[a-zA-Z\s]+$', nesne))  # Harf ve boşluktan oluşan kelimeler geçerli

while True:
    cumle = input("👤 Sen: ").lower()
    if cumle.strip() in ['exit', 'quit', 'çık']:
        print("👋 Görüşmek üzere!")
        break

    kelimeler = cumle.split()
    if len(kelimeler) < 3:
        print("⚠️ Lütfen en az bir özne, fiil ve nesne gir.")
        continue

    ozne, fiil, *nesne = kelimeler

    
    if fiil in ['go', 'goes', 'went'] and nesne:
        if yer_dogrulama(nesne[0]):
            if len(nesne) == 1 or nesne[0] != 'to':
                nesne = ['to'] + nesne

    nesne_str = ' '.join(nesne)

    try:
        if fiil in ['am', 'is', 'are']:
            query = f"to_be_cumle_dogrula_geri_bildirim('{ozne}', '{fiil}', '{nesne_str}', C, G)."
        else:
            query = f"cumle_dogrula_geri_bildirim('{ozne}', '{fiil}', '{nesne_str}', C, G)."

        sonuc = list(prolog.query(query))

        if sonuc:
            dogru_cumle = sonuc[0]["C"]
            geri_bildirim = sonuc[0]["G"]

            if "dogru gorunuyor" in geri_bildirim.lower():
                print("✅ Cümle doğru:", dogru_cumle)
            else:
                print("✅ Doğru hali:", dogru_cumle)
                print("ℹ️  Geri Bildirim:", geri_bildirim)
        else:
            print("❌ Bu cümle için kural bulunamadı.")

    except Exception as e:
        print("⚠️ Hatalı giriş veya Prolog hatası:", e)







