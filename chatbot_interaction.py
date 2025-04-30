from pyswip import Prolog

prolog = Prolog()
prolog.consult("grammar_correction.pl")

print("📘 Gramer Düzeltici Chatbot (Çıkmak için 'exit' yaz)\n")

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
    nesne_str = ' '.join(nesne)

    try:
        query = f"cumle_dogrula_geri_bildirim({ozne}, {fiil}, '{nesne_str}', C, G)."
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


